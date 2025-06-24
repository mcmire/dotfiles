#!/usr/bin/env node

const { execSync } = require('child_process');

/**
 * Analysis results for release pull requests, organized by the number of packages
 * that had version changes in each release. This helps understand how the number
 * of packages being released affects the time-to-merge.
 * @typedef {Object} ReleaseAnalysis
 * @property {Object.<number, {count: number, averageTime: string}>} [packagesChanged] - Analysis results keyed by number of packages changed
 */

/**
 * Represents a GitHub pull request with essential metadata for release analysis.
 * Contains information about when the PR was created and merged, which is used
 * to calculate time-to-merge metrics.
 * @typedef {Object} PullRequest
 * @property {number} number - The pull request number
 * @property {string} title - The pull request title
 * @property {string} createdAt - ISO string of when the PR was created
 * @property {string} mergedAt - ISO string of when the PR was merged
 */

/** @type {string} The GitHub repository owner */
const OWNER = 'MetaMask';
/** @type {string} The GitHub repository name */
const REPO = 'core';

/**
 * Fetches all merged pull requests from the MetaMask Core repository.
 * @returns {Promise<PullRequest[]>} Array of pull request objects
 * @throws {Error} When GitHub CLI command fails or JSON parsing fails
 */
async function getReleasePRs() {
  const command = `gh api \
    -X GET \
    --cache 1h \
    -H "Accept: application/vnd.github+json" \
    /search/issues \
    -f q="repo:${OWNER}/${REPO} is:pr is:merged" \
    -f per_page=100 \
    --paginate \
    -q '.items | map({number: .number, title: .title, createdAt: .created_at, mergedAt: .closed_at})'`;
  
  let output;
  try {
    output = execSync(command).toString();
  } catch (error) {
    console.error('Error executing command:', error);
    throw error;
  }

  // Split the output by lines and parse each line as a JSON array
  const lines = output.split('\n').filter(line => line.trim() !== '');
  let prs = [];
  try {
    for (const line of lines) {
      const parsedLine = JSON.parse(line);
      prs = prs.concat(parsedLine);
    }
  } catch (error) {
    console.error('Error parsing JSON:', error);
    throw error;
  }

  return prs.filter(pr => 
    (
      /^Release \d+\.\d+\.\d+$/.test(pr.title) ||
      /^Release\/\d+\.\d+\.\d+$/.test(pr.title)
    ) && 
    !pr.title.includes('Revert')
  );
}

/**
 * Counts the number of packages that had version changes in a pull request.
 * @param {number} prNumber - The pull request number to analyze
 * @returns {Promise<number>} The number of packages with version changes
 * @throws {Error} When GitHub CLI command fails or JSON parsing fails
 */
async function getPackageChanges(prNumber) {
  const command = `gh api \
    -X GET \
    --cache 1h \
    -H "Accept: application/vnd.github+json" \
    /repos/${OWNER}/${REPO}/pulls/${prNumber}/files \
    -q 'map({filename, patch})'`;
  
  let output;
  try {
    output = execSync(command).toString();
  } catch (error) {
    console.error('Error executing command:', error);
    throw error;
  }

  let files;
  try {
    files = JSON.parse(output);
  } catch (error) {
    console.error('Error parsing JSON:', error);
    throw error;
  }

  let packageJsonChanges = 0;
  for (const file of files) {
    if (file.filename.includes('/package.json')) {
      if (file.patch.includes('+  "version":') || file.patch.includes('-  "version":')) {
        packageJsonChanges++;
      }
    }
  }

  return packageJsonChanges;
}

/**
 * Calculates the time elapsed between PR creation and merge in hours.
 * @param {string} createdAt - ISO string of when the PR was created
 * @param {string} mergedAt - ISO string of when the PR was merged
 * @returns {number} Time elapsed in hours
 */
function calculateTimeElapsed(createdAt, mergedAt) {
  const created = new Date(createdAt);
  const merged = new Date(mergedAt);
  return (merged.getTime() - created.getTime()) / (1000 * 60 * 60); // Convert to hours
}

/**
 * Formats a duration in hours to a human-readable string.
 * @param {number} hours - The number of hours
 * @returns {string} Formatted duration string
 */
function formatDuration(hours) {
  return `~${Math.round(hours)} hours`;
}

/**
 * Calculates the average of an array of numbers.
 * @param {number[]} numbers - Array of numbers to average
 * @returns {number} The average value
 */
function calculateAverage(numbers) {
  return numbers.reduce((a, b) => a + b, 0) / numbers.length;
}

/**
 * Analyzes all release pull requests and groups them by the number of packages changed.
 * @returns {Promise<ReleaseAnalysis>} Analysis results grouped by packages changed
 * @throws {Error} When GitHub CLI is not authenticated or other errors occur
 */
async function analyzeReleases() {
  try {
    execSync('gh auth status');
  } catch (error) {
    throw new Error('GitHub CLI (gh) is not installed or not authenticated. Please install it and run "gh auth login"');
  }

  console.log('Fetching release PRs...');
  const releasePRs = await getReleasePRs();
  const packageGroups = {};

  console.log(`Found ${releasePRs.length} release PRs. Analyzing each PR...`);
  for (const [index, pr] of releasePRs.entries()) {
    process.stdout.write(`Analyzing PR ${index + 1}/${releasePRs.length}: #${pr.number} - ${pr.title}...`);
    
    const packagesChanged = await getPackageChanges(pr.number);
    process.stdout.write(` found ${packagesChanged} changed package${packagesChanged !== 1 ? 's' : ''}\n`);
    
    const timeElapsed = calculateTimeElapsed(pr.createdAt, pr.mergedAt);

    if (!packageGroups[packagesChanged]) {
      packageGroups[packagesChanged] = [];
    }
    packageGroups[packagesChanged].push(timeElapsed);
  }

  const results = {};
  for (const [packages, times] of Object.entries(packageGroups)) {
    const avgTime = calculateAverage(times);
    results[Number(packages)] = {
      count: times.length,
      averageTime: formatDuration(avgTime),
    };
  }

  return results;
}

/**
 * Main function that runs the release analysis.
 */
async function main() {
  try {
    const results = await analyzeReleases();
    
    console.log('\nRelease PR Analysis Results:');
    console.log('----------------------------');
    Object.entries(results)
      .sort(([a], [b]) => Number(a) - Number(b))
      .forEach(([packages, data]) => {
        console.log(`${packages} package${Number(packages) !== 1 ? 's' : ''} changed:`);
        console.log(`  Average time: ${data.averageTime}`);
        console.log(`  Number of PRs: ${data.count}`);
        console.log();
      });
  } catch (error) {
    console.error('Error:', error instanceof Error ? error.message : error);
  }
}

main().catch(console.error);