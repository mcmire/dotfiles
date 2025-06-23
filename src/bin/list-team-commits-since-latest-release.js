#!/usr/bin/env node

const fs = require("fs").promises;
const path = require("path");
const process = require("process");
const https = require("https");

/**
 * Represents a member of a GitHub team with their basic information.
 * Used to identify team members when filtering commits by authorship.
 * This type is populated from GitHub's team API and user API responses.
 * 
 * @typedef {Object} TeamMember
 * @property {string} login - GitHub username
 * @property {string} [email] - User's email address (may be undefined if not public)
 * @property {string} [name] - User's display name (may be undefined if not set)
 */

/**
 * Represents a Git commit with its metadata and author information.
 * Used throughout the script to analyze commit history and filter commits by team members.
 * This type matches the structure returned by GitHub's commits API.
 * 
 * @typedef {Object} Commit
 * @property {string} sha - Full commit SHA
 * @property {Object} commit - Commit metadata
 * @property {string} commit.message - Full commit message
 * @property {Object} commit.author - Author information
 * @property {string} commit.author.email - Author's email address
 * @property {string} commit.author.name - Author's name
 * @property {string} commit.author.date - Commit date in ISO format
 */

/**
 * Represents the command-line options and configuration for the script.
 * Used to parse and validate user input from command-line arguments.
 * All required and optional parameters are defined here.
 * 
 * @typedef {Object} ScriptOptions
 * @property {string} repo - Repository in format "owner/repo"
 * @property {string} team - GitHub team slug
 * @property {string} newReleaseBranch - New release branch name to analyze
 * @property {string} [baseReleaseBranch] - Optional explicit base branch to compare against
 * @property {string[]} [excludeBaseBranches] - Array of branch names to exclude from base consideration
 * @property {boolean} noCache - Whether to disable caching functionality
 */

/**
 * Represents a cached entry with expiration functionality.
 * Used by the caching system to store API responses and avoid repeated requests.
 * Generic type allows caching of any data structure.
 * 
 * @template T
 * @typedef {Object} CacheEntry
 * @property {T} value - The cached value
 * @property {number} expires - Expiration timestamp in milliseconds
 */

/**
 * Represents a GitHub release tag with its associated commit SHA.
 * Used to identify the latest release for comparison purposes.
 * This type is populated from GitHub's tags API response.
 * 
 * @typedef {Object} ReleaseInfo
 * @property {string} tag - Release tag name (e.g., "v1.2.3")
 * @property {string} sha - Commit SHA of the release tag
 */

/**
 * Represents a version tag with parsed version information.
 * Used internally to sort and compare version tags by semantic version.
 * The version property is extracted from the tag name for easier comparison.
 * 
 * @typedef {Object} VersionTag
 * @property {string} name - Tag name (e.g., "v1.2.3")
 * @property {string} version - Version string without 'v' prefix (e.g., "1.2.3")
 * @property {string} sha - Commit SHA of the tag
 */

/**
 * Represents a version release branch with parsed version information.
 * Used to identify and compare release branches that follow version naming conventions.
 * Supports patterns like "Version-v1.2.3" and "release/v1.2.3".
 * 
 * @typedef {Object} VersionBranch
 * @property {string} name - Branch name (e.g., "Version-v1.2.3")
 * @property {string} version - Version string without 'v' prefix (e.g., "1.2.3")
 * @property {string} sha - Commit SHA of the branch
 */

/**
 * Represents the selected base reference for commit comparison.
 * Used as the return type when determining which base to use for analysis.
 * Contains both the reference (for API calls) and display name (for logging).
 * 
 * @typedef {Object} BaseReference
 * @property {string} ref - The reference to use (branch name or SHA)
 * @property {string} name - Display name for the reference
 */

/**
 * Represents a raw branch response from GitHub's API.
 * Used when fetching all branches from a repository.
 * This is the direct structure returned by GitHub's branches API.
 * 
 * @typedef {Object} GitHubBranch
 * @property {string} name - Branch name
 * @property {Object} commit - Commit information
 * @property {string} commit.sha - Commit SHA
 */

/**
 * Represents a raw tag response from GitHub's API.
 * Used when fetching all tags from a repository.
 * This is the direct structure returned by GitHub's tags API.
 * 
 * @typedef {Object} GitHubTag
 * @property {string} name - Tag name
 * @property {Object} commit - Commit information
 * @property {string} commit.sha - Commit SHA
 */

/**
 * Represents a commit comparison response from GitHub's API.
 * Used when fetching commits between two references (branches, tags, or SHAs).
 * This is the direct structure returned by GitHub's compare API.
 * 
 * @typedef {Object} GitHubComparison
 * @property {Array<Commit>} commits - Array of commits in the comparison
 * @property {number} total_commits - Total number of commits
 * @property {string} base_commit - Base commit SHA
 * @property {string} merge_base_commit - Merge base commit SHA
 */

/**
 * Represents a GitHub user with their profile information.
 * Used when fetching individual user details to get email and name information.
 * This is the direct structure returned by GitHub's users API.
 * 
 * @typedef {Object} GitHubUser
 * @property {string} login - GitHub username
 * @property {string} [email] - User's email (may be undefined if not public)
 * @property {string} [name] - User's display name (may be undefined if not set)
 */

/**
 * Represents a team member from GitHub's team API.
 * Used when fetching team members to get basic member information.
 * This is the direct structure returned by GitHub's teams API.
 * 
 * @typedef {Object} GitHubTeamMember
 * @property {string} login - GitHub username
 * @property {string} [email] - User's email (may be undefined if not public)
 * @property {string} [name] - User's display name (may be undefined if not set)
 */

/**
 * Represents a parsed repository string.
 * Used when splitting a repository string like "owner/repo" into its components.
 * This is the result of parsing the --repo command-line argument.
 * 
 * @typedef {Object} ParsedRepo
 * @property {string} owner - Repository owner (organization or user)
 * @property {string} repo - Repository name
 */

/**
 * Represents a generic GitHub API response wrapper.
 * Used to type the responses from various GitHub API endpoints.
 * Generic type allows for different response data structures.
 * 
 * @template T
 * @typedef {Object} GitHubAPIResponse
 * @property {T} data - The response data
 * @property {number} status - HTTP status code
 * @property {Object} headers - Response headers
 */

/**
 * Compares two semantic version strings.
 * @param {string} a - First version string
 * @param {string} b - Second version string
 * @returns {number} -1 if a < b, 0 if a === b, 1 if a > b
 */
function compareVersions(a, b) {
  const partsA = a.split('.').map(Number);
  const partsB = b.split('.').map(Number);
  
  const maxLength = Math.max(partsA.length, partsB.length);
  
  for (let i = 0; i < maxLength; i++) {
    const partA = partsA[i] || 0;
    const partB = partsB[i] || 0;
    
    if (partA < partB) return -1;
    if (partA > partB) return 1;
  }
  
  return 0;
}

/**
 * Makes an HTTPS request to the GitHub API.
 * @template T
 * @param {string} url - The API endpoint URL
 * @param {string} token - GitHub Personal Access Token
 * @returns {Promise<T>} The parsed JSON response
 */
function makeGitHubRequest(url, token) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.github.com',
      path: url,
      method: 'GET',
      headers: {
        'User-Agent': 'GitHub-Commit-Analyzer',
        'Authorization': `token ${token}`,
        'Accept': 'application/vnd.github.v3+json'
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          try {
            const jsonData = JSON.parse(data);
            resolve(jsonData);
          } catch (error) {
            reject(new Error(`Failed to parse JSON response: ${error.message}`));
          }
        } else {
          reject(new Error(`GitHub API request failed with status ${res.statusCode}: ${data}`));
        }
      });
    });

    req.on('error', (error) => {
      reject(new Error(`Request failed: ${error.message}`));
    });

    req.end();
  });
}

/**
 * Ensures the cache directory exists, creating it if necessary.
 * @param {string} cacheDir - The cache directory path
 * @returns {Promise<void>}
 * @throws {Error} If directory creation fails for reasons other than already existing
 */
async function ensureCacheDir(cacheDir) {
  try {
    await fs.mkdir(cacheDir, { recursive: true });
  } catch (error) {
    if (error.code !== 'EEXIST') {
      throw error;
    }
  }
}

/**
 * Generates a safe file path for caching data based on the provided key.
 * @param {string} cacheDir - The cache directory path
 * @param {string} key - The cache key to convert to a file path
 * @returns {string} A safe file path for the cache entry
 */
function getCachePath(cacheDir, key) {
  // Replace any characters that could cause issues in filenames
  const safeKey = key.replace(/[\/\\:]/g, '_');
  return path.join(cacheDir, `${safeKey}.json`);
}

/**
 * Removes the entire cache directory and all its contents.
 * @param {string} cacheDir - The cache directory path
 * @returns {Promise<void>}
 * @throws {Error} If cache removal fails for reasons other than not existing
 */
async function clearCache(cacheDir) {
  try {
    await fs.rm(cacheDir, { recursive: true, force: true });
  } catch (error) {
    if (error.code !== 'ENOENT') {
      throw error;
    }
  }
}

/**
 * Retrieves cached data if it exists and hasn't expired.
 * @template T
 * @param {string} cacheDir - The cache directory path
 * @param {string} key - The cache key to retrieve
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<T | null>} The cached value if valid, null otherwise
 * @throws {Error} If there's an error reading or parsing the cache file
 */
async function getCached(cacheDir, key, noCache) {
  if (noCache) return null;
  
  try {
    const cachePath = getCachePath(cacheDir, key);
    const content = await fs.readFile(cachePath, 'utf8');
    const entry = JSON.parse(content);
    
    if (entry.expires < Date.now()) {
      await fs.unlink(cachePath);
      return null;
    }
    
    return entry.value;
  } catch (error) {
    if (error.code === 'ENOENT') {
      return null;
    }
    throw error;
  }
}

/**
 * Stores data in the cache with an expiration time.
 * @template T
 * @param {string} cacheDir - The cache directory path
 * @param {string} key - The cache key to store the data under
 * @param {T} value - The data to cache
 * @param {number} [ttlSeconds=3600] - Time to live in seconds (default: 1 hour)
 * @returns {Promise<void>}
 * @throws {Error} If there's an error writing the cache file
 */
async function setCached(cacheDir, key, value, ttlSeconds = 3600) {
  await ensureCacheDir(cacheDir);
  
  const entry = {
    value,
    expires: Date.now() + (ttlSeconds * 1000),
  };
  
  const cachePath = getCachePath(cacheDir, key);
  await fs.writeFile(cachePath, JSON.stringify(entry));
}

/**
 * Prints team member information to the console in a formatted table.
 * @param {TeamMember[]} members - Array of team members to display
 * @param {string} owner - Repository owner
 * @param {string} teamSlug - Team slug
 * @returns {void}
 */
function printTeamMembers(members, owner, teamSlug) {
  console.log("\n" + "=".repeat(80));
  console.log(`TEAM MEMBERS (${owner}/${teamSlug})`);
  console.log("=".repeat(80));
  
  members.forEach((member, index) => {
    console.log(`${index + 1}. ${member.login}${member.name ? ` (${member.name})` : ''}${member.email ? ` <${member.email}>` : ''}`);
  });
  console.log("=".repeat(80) + "\n");
}

/**
 * Fetches team members from GitHub API with their details (name and email).
 * Uses caching to avoid repeated API calls for the same team.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} teamSlug - Team slug
 * @param {string} cacheDir - Cache directory path
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<TeamMember[]>} Array of team members with their details
 * @throws {Error} If the API request fails or team members cannot be fetched
 */
async function getTeamMembers(token, owner, teamSlug, cacheDir, noCache) {
  try {
    const cacheKey = `team_members_${owner}_${teamSlug}`;
    const cached = await getCached(cacheDir, cacheKey, noCache);
    if (cached) {
      console.log(`Using cached team members for ${owner}/${teamSlug}`);
      printTeamMembers(cached, owner, teamSlug);
      return cached;
    }

    console.log(`Fetching team members from ${owner}/${teamSlug}...`);
    const members = await makeGitHubRequest(`/orgs/${owner}/teams/${teamSlug}/members`, token);

    const membersWithDetails = [];

    for (const member of members) {
      try {
        const user = await makeGitHubRequest(`/users/${member.login}`, token);

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

    await setCached(cacheDir, cacheKey, membersWithDetails);
    console.log(`Found ${membersWithDetails.length} team members`);
    printTeamMembers(membersWithDetails, owner, teamSlug);
    return membersWithDetails;
  } catch (error) {
    throw new Error(`Failed to fetch team members: ${error}`);
  }
}

/**
 * Fetches the latest release tag from the repository.
 * Filters for semantic version tags (v1.0.0 format) and returns the most recent one.
 * Uses caching to avoid repeated API calls.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} cacheDir - Cache directory path
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<ReleaseInfo>} Object containing the latest release tag and SHA
 * @throws {Error} If no valid version tags are found or the API request fails
 */
async function getLatestRelease(token, owner, repo, cacheDir, noCache) {
  try {
    const cacheKey = `latest_release_${owner}_${repo}`;
    const cached = await getCached(cacheDir, cacheKey, noCache);
    if (cached) {
      console.log(`Using cached latest release for ${owner}/${repo}`);
      return cached;
    }

    console.log(`Fetching latest release tag from ${owner}/${repo}...`);
    const tags = await makeGitHubRequest(`/repos/${owner}/${repo}/tags?per_page=100`, token);

    const versionTags = tags
      .filter((/** @type {GitHubTag} */ tag) => tag.name.startsWith('v'))
      .map((/** @type {GitHubTag} */ tag) => ({
        name: tag.name,
        version: tag.name.substring(1),
        sha: tag.commit.sha,
      }))
      .filter((/** @type {VersionTag} */ tag) => {
        try {
          return /^\d+\.\d+\.\d+/.test(tag.version);
        } catch {
          return false;
        }
      });

    if (versionTags.length === 0) {
      throw new Error("No valid version tags found");
    }

    versionTags.sort((/** @type {VersionTag} */ a, /** @type {VersionTag} */ b) => compareVersions(b.version, a.version));
    
    const latestTag = versionTags[0];
    const releaseInfo = {
      tag: latestTag.name,
      sha: latestTag.sha,
    };
    await setCached(cacheDir, cacheKey, releaseInfo);
    console.log(`Latest release: ${latestTag.name}`);
    return releaseInfo;
  } catch (error) {
    throw new Error(`Failed to get latest release: ${error}`);
  }
}

/**
 * Fetches all branches from the repository.
 * Uses caching to avoid repeated API calls.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} cacheDir - Cache directory path
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<Array<{name: string, commit: {sha: string}}>>} Array of branches
 * @throws {Error} If the API request fails or branches cannot be fetched
 */
async function getAllBranches(token, owner, repo, cacheDir, noCache) {
  try {
    const cacheKey = `all_branches_${owner}_${repo}`;
    const cached = await getCached(cacheDir, cacheKey, noCache);
    if (cached) {
      console.log(`Using cached branches for ${owner}/${repo}`);
      return cached;
    }

    console.log(`Fetching all branches from ${owner}/${repo}...`);
    
    let allBranches = [];
    let page = 1;
    const perPage = 100;
    
    while (true) {
      const branches = await makeGitHubRequest(`/repos/${owner}/${repo}/branches?per_page=${perPage}&page=${page}`, token);
      
      allBranches = allBranches.concat(branches);
      
      // If we got fewer branches than the page size, we've reached the end
      if (branches.length < perPage) {
        break;
      }
      
      page++;
    }
    
    await setCached(cacheDir, cacheKey, allBranches);
    console.log(`Found ${allBranches.length} branches`);
    return allBranches;
  } catch (error) {
    throw new Error(`Failed to fetch branches: ${error}`);
  }
}

/**
 * Finds the highest version release branch that matches the version pattern.
 * Looks for branches matching 'Version-vX.Y.Z' or 'release/vX.Y.Z' patterns.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} excludeBranch - Branch name to exclude from consideration
 * @param {string[]} additionalExcludeBranches - Additional branch names to exclude
 * @param {string} cacheDir - Cache directory path
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<{name: string, version: string, sha: string} | null>} The highest version branch or null if none found
 * @throws {Error} If the API request fails
 */
async function findHighestVersionReleaseBranch(token, owner, repo, excludeBranch, additionalExcludeBranches, cacheDir, noCache) {
  try {
    const branches = await getAllBranches(token, owner, repo, cacheDir, noCache);
    
    const releaseBranchPatterns = [
      /^Version-v(\d+\.\d+\.\d+)$/,  // Version-v1.2.3
      /^release\/v(\d+\.\d+\.\d+)$/  // release/v1.2.3
    ];
    
    const versionBranches = [];
    const allExcludedBranches = [excludeBranch, ...additionalExcludeBranches];
    
    for (const branch of branches) {
      // Skip excluded branches
      if (allExcludedBranches.includes(branch.name)) {
        console.log(`Excluding branch: ${branch.name}`);
        continue;
      }
      
      // Check if branch matches any of our version patterns
      for (const pattern of releaseBranchPatterns) {
        const match = branch.name.match(pattern);
        if (match) {
          versionBranches.push({
            name: branch.name,
            version: match[1],
            sha: branch.commit.sha
          });
          break; // Found a match, no need to check other patterns
        }
      }
    }
    
    if (versionBranches.length === 0) {
      console.log("No version release branches found");
      return null;
    }
    
    // Sort by version and return the highest
    versionBranches.sort((a, b) => compareVersions(b.version, a.version));
    const highestVersionBranch = versionBranches[0];
    
    console.log(`Found highest version release branch: ${highestVersionBranch.name} (v${highestVersionBranch.version})`);
    return highestVersionBranch;
  } catch (error) {
    throw new Error(`Failed to find highest version release branch: ${error}`);
  }
}

/**
 * Gets the default base reference (highest version release branch or latest release).
 * Compares the highest version branch with the highest version tag and uses the higher one.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} excludeBranch - Branch name to exclude from consideration
 * @param {string[]} additionalExcludeBranches - Additional branch names to exclude
 * @param {string} cacheDir - Cache directory path
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<{ref: string, name: string}>} The base reference and its display name
 * @throws {Error} If no valid base reference can be found
 */
async function getDefaultBaseReference(token, owner, repo, excludeBranch, additionalExcludeBranches, cacheDir, noCache) {
  try {
    // Get both the highest version release branch and the latest release tag
    const [highestVersionBranch, latestRelease] = await Promise.all([
      findHighestVersionReleaseBranch(token, owner, repo, excludeBranch, additionalExcludeBranches, cacheDir, noCache),
      getLatestRelease(token, owner, repo, cacheDir, noCache)
    ]);
    
    if (!latestRelease.sha || !latestRelease.tag) {
      throw new Error("Failed to get latest release information");
    }
    
    // If we don't have any version branches, use the latest release tag
    if (!highestVersionBranch) {
      console.log(`No version release branches found, using latest release tag: ${latestRelease.tag}`);
      return {
        ref: latestRelease.sha,
        name: latestRelease.tag
      };
    }
    
    // Extract version from the latest release tag (remove 'v' prefix)
    const latestReleaseVersion = latestRelease.tag.substring(1);
    
    // Compare the versions
    const versionComparison = compareVersions(highestVersionBranch.version, latestReleaseVersion);
    
    if (versionComparison > 0) {
      // Branch version is higher than tag version
      console.log(`Branch ${highestVersionBranch.name} (v${highestVersionBranch.version}) is newer than tag ${latestRelease.tag} (v${latestReleaseVersion})`);
      return {
        ref: highestVersionBranch.name,
        name: highestVersionBranch.name
      };
    } else if (versionComparison < 0) {
      // Tag version is higher than branch version
      console.log(`Tag ${latestRelease.tag} (v${latestReleaseVersion}) is newer than branch ${highestVersionBranch.name} (v${highestVersionBranch.version})`);
      return {
        ref: latestRelease.sha,
        name: latestRelease.tag
      };
    } else {
      // Versions are equal, prefer the tag (as it's likely more stable)
      console.log(`Branch ${highestVersionBranch.name} and tag ${latestRelease.tag} have the same version (v${latestReleaseVersion}), preferring tag`);
      return {
        ref: latestRelease.sha,
        name: latestRelease.tag
      };
    }
  } catch (error) {
    throw new Error(`Failed to get default base reference: ${error}`);
  }
}

/**
 * Fetches all commits between a base reference and a head branch.
 * Handles pagination to retrieve all commits if there are more than 100.
 * Uses caching to avoid repeated API calls for the same comparison.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} baseRef - The base reference (branch name or SHA)
 * @param {string} headBranch - The head branch name to compare against
 * @param {string} baseRefName - The base reference name (for logging purposes)
 * @param {string} cacheDir - Cache directory path
 * @param {boolean} noCache - Whether to disable caching
 * @returns {Promise<Commit[]>} Array of commits between the base and head
 * @throws {Error} If the API request fails or commits cannot be fetched
 */
async function getCommitsBetween(token, owner, repo, baseRef, headBranch, baseRefName, cacheDir, noCache) {
  try {
    const cacheKey = `commits_${owner}_${repo}_${baseRef}_${headBranch}`;
    const cached = await getCached(cacheDir, cacheKey, noCache);
    if (cached) {
      console.log(`Using cached commits between ${baseRefName} and ${headBranch}`);
      return cached;
    }

    console.log(`Fetching commits between ${baseRefName} and ${headBranch}...`);
    
    let allCommits = [];
    let page = 1;
    const perPage = 100;
    
    while (true) {
      const comparison = await makeGitHubRequest(
        `/repos/${owner}/${repo}/compare/${baseRef}...${headBranch}?per_page=${perPage}&page=${page}`,
        token
      );

      allCommits = allCommits.concat(comparison.commits);
      
      // If we got fewer commits than the page size, we've reached the end
      if (comparison.commits.length < perPage) {
        break;
      }
      
      page++;
    }

    await setCached(cacheDir, cacheKey, allCommits);
    console.log(`Found ${allCommits.length} commits`);
    return allCommits;
  } catch (error) {
    throw new Error(`Failed to get commits: ${error}`);
  }
}

/**
 * Filters commits to only include those authored by team members.
 * Matches commit authors against team members by email, name, or GitHub username.
 * @param {Commit[]} commits - Array of commits to filter
 * @param {TeamMember[]} teamMembers - Array of team members to match against
 * @returns {Commit[]} Array of commits authored by team members
 */
function filterCommitsByTeamMembers(commits, teamMembers) {
  console.log("Filtering commits by team members...");
  
  // Create sets for faster lookup
  const teamEmails = new Set();
  const teamLogins = new Set();
  const teamNames = new Set();
  
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

/**
 * Outputs the filtered commits to the console in a formatted list.
 * Shows commit SHA, subject line, author information, and date for each commit.
 * @param {Commit[]} commits - Array of commits to display
 * @param {string} teamSlug - Team slug for display
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @returns {void}
 */
function outputResults(commits, teamSlug, owner, repo) {
  console.log("\n" + "=".repeat(80));
  console.log(`COMMITS BY ${teamSlug.toUpperCase()} TEAM MEMBERS`);
  console.log(`Repository: ${owner}/${repo}`);
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

/**
 * Main analysis function that orchestrates the entire process.
 * Fetches team members, gets the base reference (specified branch, highest version release branch, or latest release),
 * retrieves commits, filters them by team members, and outputs the results.
 * @param {string} token - GitHub Personal Access Token
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} teamSlug - Team slug
 * @param {string} newReleaseBranch - The new release branch name to analyze commits for
 * @param {string} [baseReleaseBranch] - Optional base branch to compare against (defaults to highest version release branch or latest release)
 * @param {string[]} [excludeBaseBranches] - Optional array of branch names to exclude from base consideration
 * @param {boolean} [noCache=false] - Whether to disable caching functionality
 * @returns {Promise<void>}
 * @throws {Error} If any step in the analysis process fails
 */
async function analyzeCommits(token, owner, repo, teamSlug, newReleaseBranch, baseReleaseBranch = null, excludeBaseBranches = [], noCache = false) {
  try {
    const cacheDir = ".cache";
    
    // Get team members
    const teamMembers = await getTeamMembers(token, owner, teamSlug, cacheDir, noCache);
    
    let baseRef, baseRefName;
    
    if (baseReleaseBranch) {
      // Use specified base branch
      baseRef = baseReleaseBranch;
      baseRefName = baseReleaseBranch;
      console.log(`Using ${baseReleaseBranch} as base reference`);
    } else {
      // Use default base reference (highest version release branch or latest release)
      const defaultBase = await getDefaultBaseReference(token, owner, repo, newReleaseBranch, excludeBaseBranches, cacheDir, noCache);
      baseRef = defaultBase.ref;
      baseRefName = defaultBase.name;
      console.log(`Using ${baseRefName} as default base reference`);
    }
    
    // Get commits between base reference and new release branch
    const commits = await getCommitsBetween(token, owner, repo, baseRef, newReleaseBranch, baseRefName, cacheDir, noCache);
    
    // Filter commits by team members
    const teamCommits = filterCommitsByTeamMembers(commits, teamMembers);
    
    // Output results
    outputResults(teamCommits, teamSlug, owner, repo);
    
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

/**
 * @returns {ScriptOptions}
 */
function parseOptions() {
  try {
    const args = process.argv.slice(2);
    const options = {};
    
    for (let i = 0; i < args.length; i++) {
      const arg = args[i];
      if (arg === "--help" || arg === "-h") {
        printUsage();
        process.exit(0);
      }
      
      if (arg === "--repo" || arg === "-r") {
        options.repo = args[++i];
      } else if (arg === "--team" || arg === "-t") {
        options.team = args[++i];
      } else if (arg === "--new-release-branch" || arg === "-n") {
        options.newReleaseBranch = args[++i];
      } else if (arg === "--base-release-branch" || arg === "-b") {
        options.baseReleaseBranch = args[++i];
      } else if (arg === "--exclude-base-branch" || arg === "-e") {
        if (!options.excludeBaseBranches) {
          options.excludeBaseBranches = [];
        }
        options.excludeBaseBranches.push(args[++i]);
      } else if (arg === "--no-cache") {
        options.noCache = true;
      }
    }

    if (!options.repo || !options.team || !options.newReleaseBranch) {
      console.error("Error: Missing required options\n");
      printUsage();
      process.exit(1);
    }

    return {
      repo: options.repo,
      team: options.team,
      newReleaseBranch: options.newReleaseBranch,
      baseReleaseBranch: options.baseReleaseBranch,
      excludeBaseBranches: options.excludeBaseBranches || [],
      noCache: options.noCache === true,
    };
  } catch (error) {
    console.error("Error parsing arguments:", error);
    printUsage();
    process.exit(1);
  }
}

function printUsage() {
  const scriptName = path.basename(process.argv[1]);
  
  console.log(`
${scriptName}

Get a list of commits for a particular release that belong to a specific MetaMask team. Useful when validating a release.

The base release can be customized (but defaults to the latest release).

Usage:
  ./${scriptName} --repo <owner/repo> --team <team-slug> --new-release-branch <branch> [--base-release-branch <branch>] [--exclude-base-branch <branch>] [--no-cache]

Options:
  -r, --repo <owner/repo>               Repository in format "owner/repo" (e.g., "MetaMask/metamask-extension")
  -t, --team <team-slug>                GitHub team slug, minus "MetaMask/" (e.g., "wallet-framework")
  -n, --new-release-branch <branch>     New release branch name to fetch commits for
  -b, --base-release-branch <branch>    Base branch to compare against (defaults to latest working release branch or latest tag)
  -e, --exclude-base-branch <branch>    Exclude a branch from being considered as the default base (can be specified multiple times), for instance to omit skipped releases
  --no-cache                            Disable caching / clear existing cache
  -h, --help                            Show this help message

Environment Variables:
  GITHUB_TOKEN                          GitHub personal access token (required). You'll need to set this up first.

Examples:
  # List commits by team members between latest release and new release branch
  ./${scriptName} --repo MetaMask/metamask-extension --team wallet-framework --new-release-branch main
  
  # List commits by team members between a specific base branch and new release branch
  ./${scriptName} --repo MetaMask/metamask-extension --team wallet-framework --new-release-branch main --base-release-branch develop
  
  # Exclude a specific branch from being considered as the default base
  ./${scriptName} --repo MetaMask/metamask-extension --team wallet-framework --new-release-branch main --exclude-base-branch Version-v12.21.0
  
  # Exclude multiple branches from being considered as the default base
  ./${scriptName} --repo MetaMask/metamask-extension --team wallet-framework --new-release-branch main --exclude-base-branch Version-v12.21.0 --exclude-base-branch release/v12.20.0
  
  # Using short options
  ./${scriptName} -r MetaMask/metamask-extension -t wallet-framework -n main -e Version-v12.21.0 --no-cache
`);
}

/**
 * @param {string} repoString
 * @returns {{ owner: string, repo: string }}
 */
function parseRepoString(repoString) {
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
  // Check for help flag first, before requiring GITHUB_TOKEN
  const args = process.argv.slice(2);
  if (args.includes('--help') || args.includes('-h')) {
    printUsage();
    process.exit(0);
  }

  const token = process.env.GITHUB_TOKEN;

  if (!token) {
    console.error("Error: Please set GITHUB_TOKEN environment variable");
    console.error("You can create a token at: https://github.com/settings/tokens");
    process.exit(1);
  }

  const options = parseOptions();
  const { owner, repo } = parseRepoString(options.repo);

  console.log(`Configuration:
  Repository: ${owner}/${repo}
  Team: ${options.team}
  New Release Branch: ${options.newReleaseBranch}
  Base Reference: ${options.baseReleaseBranch || 'highest version release branch or latest release tag'}
  Excluded Base Branches: ${options.excludeBaseBranches.length > 0 ? options.excludeBaseBranches.join(', ') : 'none'}
  Cache: ${options.noCache ? 'disabled' : 'enabled'}
`);

  await analyzeCommits(
    token,
    owner,
    repo,
    options.team,
    options.newReleaseBranch,
    options.baseReleaseBranch,
    options.excludeBaseBranches,
    options.noCache
  );
}

if (require.main === module) {
  main().catch(console.error);
} 