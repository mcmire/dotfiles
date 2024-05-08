frequently-used-commands() {
  history | \
    sed -E 's/^[ ]+//; s/\|.*//' | \
    cut -d ' ' -f 3- | \
    awk '{ a[$0]++ } END { for (i in a) { print a[i] " " i } }' | \
    sort -rn | \
    head
}

# Credit: Ben Orenstein
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}
compdef g=git

git-fix-db() {
  git-undo db/schema.rb
  Rm
}

git-fix-rb() {
  git-undo Gemfile.lock
  bundle
}

git-fix-js() {
  if [[ -f package-lock.json ]]; then
    git-undo package-lock.json
    npm install
  fi

  if [[ -f yarn.lock ]]; then
    git-undo yarn.lock
    yarn install
  fi
}

_git_delete_branch_and_remote() {
  __gitcomp_nl "$(__git_heads)"
}

_git_undo() {
  __gitcomp_nl "$(__git_heads)"
}

bau() {
  bundle update "$1" && be appraisal update "$1"
}

compare() {
  colordiff -u "$@" | less -R
}

new-rails-app() {
  rails new "$1" \
    --skip-action-cable \
    --skip-test \
    --skip-turbolinks \
    --skip-action-mailbox \
    --skip-sprockets \
    --skip-active-storage \
    --webpacker react \
    "${2:@}"
}

jf() {
  local workspaces="$(cat package.json | jq '.workspaces')"
  local workspace_package_name="$1"
  local workspace_package_names

  if [[ $workspaces == "null" ]]; then
    # polyrepo
    yarn jest "$@" --verbose=false --no-coverage
  else
    # monorepo
    if [[ -z $workspace_package_name ]]; then
      workspace_package_names="$(yarn workspaces list --json | jq --slurp --raw-output 'map(.name) | .[]')"
      echo "ERROR: Missing workspace package name. Possible package names are:"
      echo
      echo "$workspace_package_names"
      echo
      exit 1
    fi

    yarn workspace "$workspace_package_name" run jest "${@:2}" --verbose=false --no-coverage
  fi
}

jfw() {
  jf "$@" --watch
}

yw() {
  local command="workspace"
  if [[ $1 == "focus" || $1 == "foreach" || $1 == "list" ]]; then
    command="workspaces"
  fi

  yarn $command "$@"
}
