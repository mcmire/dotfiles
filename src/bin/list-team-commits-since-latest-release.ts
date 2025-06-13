#!/usr/bin/env deno run --allow-net --allow-env --allow-read --allow-write

import { Octokit } from "@octokit/rest";
import { compare } from "semver";

interface TeamMember {
  login: string;
  email?: string;
  name?: string;
}

interface Commit {
  sha: string;
  commit: {
    message: string;
    author: {
      email: string;
      name: string;
      date: string;
    };
  };
}

interface ScriptOptions {
  repo: string;
  team: string;
  branchName: string;
  noCache: boolean;
}

interface CacheEntry<T> {
  value: T;
  expires: number;
}

interface ReleaseInfo {
  tag: string;
  sha: string;
}

class GitHubCommitAnalyzer {
  private octokit: Octokit;
  private owner: string;
  private repo: string;
  private teamSlug: string;
  private noCache: boolean;
  private cacheDir: string;

  constructor(token: string, owner: string, repo: string, teamSlug: string, noCache: boolean = false) {
    this.octokit = new Octokit({
      auth: token,
    });
    this.owner = owner;
    this.repo = repo;
    this.teamSlug = teamSlug;
    this.noCache = noCache;
    this.cacheDir = ".cache";
  }

  private async ensureCacheDir() {
    try {
      await Deno.mkdir(this.cacheDir, { recursive: true });
    } catch (error) {
      if (!(error instanceof Deno.errors.AlreadyExists)) {
        throw error;
      }
    }
  }

  private getCachePath(key: string): string {
    // Replace any characters that could cause issues in filenames
    const safeKey = key.replace(/[\/\\:]/g, '_');
    return `${this.cacheDir}/${safeKey}.json`;
  }

  private async clearCache() {
    try {
      await Deno.remove(this.cacheDir, { recursive: true });
    } catch (error) {
      if (!(error instanceof Deno.errors.NotFound)) {
        throw error;
      }
    }
  }

  private async getCached<T>(key: string): Promise<T | null> {
    if (this.noCache) return null;
    
    try {
      const cachePath = this.getCachePath(key);
      const content = await Deno.readTextFile(cachePath);
      const entry: CacheEntry<T> = JSON.parse(content);
      
      if (entry.expires < Date.now()) {
        await Deno.remove(cachePath);
        return null;
      }
      
      return entry.value;
    } catch (error) {
      if (error instanceof Deno.errors.NotFound) {
        return null;
      }
      throw error;
    }
  }

  private async setCached<T>(key: string, value: T, ttlSeconds: number = 3600) {
    await this.ensureCacheDir();
    
    const entry: CacheEntry<T> = {
      value,
      expires: Date.now() + (ttlSeconds * 1000),
    };
    
    const cachePath = this.getCachePath(key);
    await Deno.writeTextFile(cachePath, JSON.stringify(entry));
  }

  private printTeamMembers(members: TeamMember[]): void {
    console.log("\n" + "=".repeat(80));
    console.log(`TEAM MEMBERS (${this.owner}/${this.teamSlug})`);
    console.log("=".repeat(80));
    
    members.forEach((member, index) => {
      console.log(`${index + 1}. ${member.login}${member.name ? ` (${member.name})` : ''}${member.email ? ` <${member.email}>` : ''}`);
    });
    console.log("=".repeat(80) + "\n");
  }

  async getTeamMembers(): Promise<TeamMember[]> {
    try {
      const cacheKey = `team_members_${this.owner}_${this.teamSlug}`;
      const cached = await this.getCached<TeamMember[]>(cacheKey);
      if (cached) {
        console.log(`Using cached team members for ${this.owner}/${this.teamSlug}`);
        this.printTeamMembers(cached);
        return cached;
      }

      console.log(`Fetching team members from ${this.owner}/${this.teamSlug}...`);
      const { data: members } = await this.octokit.rest.teams.listMembersInOrg({
        org: this.owner,
        team_slug: this.teamSlug,
      });

      const membersWithDetails: TeamMember[] = [];

      for (const member of members) {
        try {
          const { data: user } = await this.octokit.rest.users.getByUsername({
            username: member.login,
          });

          membersWithDetails.push({
            login: member.login,
            email: user.email,
            name: user.name,
          });
        } catch (error) {
          console.warn(`Could not fetch details for user ${member.login}`);
          membersWithDetails.push({
            login: member.login,
            email: undefined,
            name: undefined,
          });
        }
      }

      await this.setCached(cacheKey, membersWithDetails);
      console.log(`Found ${membersWithDetails.length} team members`);
      this.printTeamMembers(membersWithDetails);
      return membersWithDetails;
    } catch (error) {
      throw new Error(`Failed to fetch team members: ${error}`);
    }
  }

  async getLatestRelease(): Promise<ReleaseInfo> {
    try {
      const cacheKey = `latest_release_${this.owner}_${this.repo}`;
      const cached = await this.getCached<ReleaseInfo>(cacheKey);
      if (cached) {
        console.log(`Using cached latest release for ${this.owner}/${this.repo}`);
        return cached;
      }

      console.log(`Fetching latest release tag from ${this.owner}/${this.repo}...`);
      const { data: tags } = await this.octokit.rest.repos.listTags({
        owner: this.owner,
        repo: this.repo,
        per_page: 100,
      });

      const versionTags = tags
        .filter(tag => tag.name.startsWith('v'))
        .map(tag => ({
          name: tag.name,
          version: tag.name.substring(1),
          sha: tag.commit.sha,
        }))
        .filter(tag => {
          try {
            return /^\d+\.\d+\.\d+/.test(tag.version);
          } catch {
            return false;
          }
        });

      if (versionTags.length === 0) {
        throw new Error("No valid version tags found");
      }

      versionTags.sort((a, b) => compare(b.version, a.version));
      
      const latestTag = versionTags[0];
      const releaseInfo: ReleaseInfo = {
        tag: latestTag.name,
        sha: latestTag.sha,
      };
      await this.setCached(cacheKey, releaseInfo);
      console.log(`Latest release: ${latestTag.name}`);
      return releaseInfo;
    } catch (error) {
      throw new Error(`Failed to get latest release: ${error}`);
    }
  }

  async getCommitsBetween(baseSha: string, headBranch: string, baseTag: string): Promise<Commit[]> {
    try {
      const cacheKey = `commits_${this.owner}_${this.repo}_${baseSha}_${headBranch}`;
      const cached = await this.getCached<Commit[]>(cacheKey);
      if (cached) {
        console.log(`Using cached commits between ${baseTag} and ${headBranch}`);
        return cached;
      }

      console.log(`Fetching commits between ${baseTag} and ${headBranch}...`);
      
      let allCommits: Commit[] = [];
      let page = 1;
      const perPage = 100;
      
      while (true) {
        const { data: comparison } = await this.octokit.rest.repos.compareCommits({
          owner: this.owner,
          repo: this.repo,
          base: baseSha,
          head: headBranch,
          per_page: perPage,
          page,
        });

        allCommits = allCommits.concat(comparison.commits);
        
        // If we got fewer commits than the page size, we've reached the end
        if (comparison.commits.length < perPage) {
          break;
        }
        
        page++;
      }

      await this.setCached(cacheKey, allCommits);
      console.log(`Found ${allCommits.length} commits`);
      return allCommits;
    } catch (error) {
      throw new Error(`Failed to get commits: ${error}`);
    }
  }

  filterCommitsByTeamMembers(commits: Commit[], teamMembers: TeamMember[]): Commit[] {
    console.log("Filtering commits by team members...");
    
    // Create sets for faster lookup
    const teamEmails = new Set<string>();
    const teamLogins = new Set<string>();
    const teamNames = new Set<string>();
    
    teamMembers.forEach(member => {
      if (member.email) {
        teamEmails.add(member.email.toLowerCase());
      }
      teamLogins.add(member.login.toLowerCase());
      if (member.name) {
        teamNames.add(member.name.toLowerCase());
      }
    });

    const filteredCommits = commits.filter(commit => {
      const authorEmail = commit.commit.author.email.toLowerCase();
      const authorName = commit.commit.author.name.toLowerCase();
      
      // Check if commit author email matches any team member email
      if (teamEmails.has(authorEmail)) {
        return true;
      }
      
      // Check if author name matches any team member name
      if (teamNames.has(authorName)) {
        return true;
      }
      
      // Check if author name matches any GitHub username (fallback)
      if (teamLogins.has(authorName)) {
        return true;
      }
      
      return false;
    });

    console.log(`Found ${filteredCommits.length} commits by team members`);
    return filteredCommits;
  }

  outputResults(commits: Commit[]): void {
    console.log("\n" + "=".repeat(80));
    console.log(`COMMITS BY ${this.teamSlug.toUpperCase()} TEAM MEMBERS`);
    console.log(`Repository: ${this.owner}/${this.repo}`);
    console.log("=".repeat(80));

    if (commits.length === 0) {
      console.log("No commits found by team members in the specified range.");
      return;
    }

    commits.forEach((commit, index) => {
      const subject = commit.commit.message.split('\n')[0]; // Get first line as subject
      const date = new Date(commit.commit.author.date).toLocaleString();
      console.log(`${index + 1}. ${commit.sha.substring(0, 7)} - ${subject}`);
      console.log(`   Author: ${commit.commit.author.name} <${commit.commit.author.email}>`);
      console.log(`   Date: ${date}`);
      console.log("");
    });
  }

  async analyze(branchName: string): Promise<void> {
    try {
      // Get team members
      const teamMembers = await this.getTeamMembers();
      
      // Get latest release
      const latestRelease = await this.getLatestRelease();
      if (!latestRelease.sha || !latestRelease.tag) {
        throw new Error("Failed to get latest release information");
      }
      
      // Get commits between latest release and specified branch
      const commits = await this.getCommitsBetween(latestRelease.sha, branchName, latestRelease.tag);
      
      // Filter commits by team members
      const teamCommits = this.filterCommitsByTeamMembers(commits, teamMembers);
      
      // Output results
      this.outputResults(teamCommits);
      
    } catch (error) {
      console.error("Error:", error);
      Deno.exit(1);
    }
  }
}

function parseOptions(): ScriptOptions {
  try {
    const args = Deno.args;
    const options: Record<string, string | boolean> = {};
    
    for (let i = 0; i < args.length; i++) {
      const arg = args[i];
      if (arg === "--help" || arg === "-h") {
        printUsage();
        Deno.exit(0);
      }
      
      if (arg === "--repo" || arg === "-r") {
        options.repo = args[++i];
      } else if (arg === "--team" || arg === "-t") {
        options.team = args[++i];
      } else if (arg === "--branch-name" || arg === "-b") {
        options["branch-name"] = args[++i];
      } else if (arg === "--no-cache") {
        options.noCache = true;
      }
    }

    if (!options.repo || !options.team || !options["branch-name"]) {
      console.error("Error: Missing required options\n");
      printUsage();
      Deno.exit(1);
    }

    return {
      repo: options.repo as string,
      team: options.team as string,
      branchName: options["branch-name"] as string,
      noCache: options.noCache === true,
    };
  } catch (error) {
    console.error("Error parsing arguments:", error);
    printUsage();
    Deno.exit(1);
  }
}

function printUsage(): void {
  console.log(`
GitHub Commit Analyzer

Analyzes commits in a repository by team members between the latest release and a specified branch.

Usage:
  deno run --allow-net --allow-env --allow-read --allow-write script.ts --repo <owner/repo> --team <team-slug> --branch-name <branch> [--no-cache]

Options:
  -r, --repo <owner/repo>     Repository in format "owner/repo" (e.g., "MetaMask/metamask-extension")
  -t, --team <team-slug>      GitHub team slug (e.g., "wallet-framework")
  -b, --branch-name <branch>  Branch name to compare against latest release
  --no-cache                  Disable caching and clear existing cache
  -h, --help                  Show this help message

Environment Variables:
  GITHUB_TOKEN               GitHub Personal Access Token (required)

Examples:
  deno run --allow-net --allow-env --allow-read --allow-write script.ts --repo MetaMask/metamask-extension --team wallet-framework --branch-name main
  deno run --allow-net --allow-env --allow-read --allow-write script.ts -r MetaMask/metamask-extension -t wallet-framework -b develop --no-cache
`);
}

function parseRepoString(repoString: string): { owner: string; repo: string } {
  const parts = repoString.split('/');
  if (parts.length !== 2) {
    throw new Error('Repository must be in format "owner/repo"');
  }
  return {
    owner: parts[0],
    repo: parts[1],
  };
}

// Main execution
async function main() {
  const token = Deno.env.get("GITHUB_TOKEN");

  if (!token) {
    console.error("Error: Please set GITHUB_TOKEN environment variable");
    console.error("You can create a token at: https://github.com/settings/tokens");
    Deno.exit(1);
  }

  const options = parseOptions();
  const { owner, repo } = parseRepoString(options.repo);

  console.log(`Configuration:
  Repository: ${owner}/${repo}
  Team: ${options.team}
  Branch: ${options.branchName}
  Cache: ${options.noCache ? 'disabled' : 'enabled'}
`);

  const analyzer = new GitHubCommitAnalyzer(token, owner, repo, options.team, options.noCache);
  await analyzer.analyze(options.branchName);
}

if (import.meta.main) {
  main().catch(console.error);
}
