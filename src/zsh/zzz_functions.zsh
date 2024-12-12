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
  local workspaces
  local command_args
  local parse_rest_as_command_args=0
  local workspace_package_name
  local workspace_package_names

  workspaces="$(cat package.json | jq '.workspaces')"

  if [[ $workspaces == "null" ]]; then
    # Polyrepo
    yarn jest "$@" --verbose=false --no-coverage
  else
    # Monorepo

    command_args=()
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --)
          parse_rest_as_command_args=1
          shift
          ;;
        -*)
          if [[ -n "$workspace_package_name" && $parse_rest_as_command_args -eq 0 ]]; then
            echo "ERROR: Unrecognized argument \`$1\`."
            echo "Use \`--\` if you meant this to be an argument to the \`yarn workspace\` command."
            return 1
          fi
          command_args+=("$1")
          shift
          ;;
        *)
          if [[ $#command_args -gt 0 ]]; then
            echo "ERROR: Unrecognized argument \`$1\`."
            echo "Use \`--\` if you meant this to be an argument to the \`yarn workspace\` command."
            return 1
          fi

          if [[ $parse_rest_as_command_args -eq 1 ]]; then
            command_args+=("$1")
          else
            workspace_package_name="$1"
          fi
          shift
          ;;
      esac
    done

    if [[ -z $workspace_package_name ]]; then
      workspace_package_names="$(yarn workspaces list --json | jq --slurp --raw-output 'map(.name) | .[]')"
      echo "ERROR: Missing workspace package name. Possible package names are:"
      echo
      echo "$workspace_package_names"
      echo
      return 1
    fi

    yarn workspace "$workspace_package_name" exec jest "${command_args[@]}" --verbose=false --no-coverage
  fi
}

jfw() {
  jf "$@" -- --watch
}

yw() {
  local command="workspace"
  if [[ $1 == "focus" || $1 == "foreach" || $1 == "list" ]]; then
    command="workspaces"
  fi

  yarn $command "$@"
}

ywd() {
  yw "$1" run since-latest-release -- diff
}

ywdh() {
  yw "$1" run since-latest-release --include-head -- diff
}
