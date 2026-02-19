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
  local is_monorepo
  local workspaces
  local command_args
  local workspace_package_name
  local workspace_package_names

  local verbose=0
  local parse_rest_as_command_args=0

  workspaces="$(cat package.json | jq '.workspaces')"
  if [[ $workspaces == "null" ]]; then
    is_monorepo=0
  else
    is_monorepo=1
  fi

  command_args=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --verbose)
        verbose=1
        shift
        ;;
      --)
        parse_rest_as_command_args=1
        shift
        ;;
      -*)
        if [[ $is_monorepo -eq 1 && -n "$workspace_package_name" && $parse_rest_as_command_args -eq 0 ]]; then
          echo "ERROR: Unrecognized argument \`$1\`."
          echo "Use \`--\` if you meant this to be an argument to the \`yarn workspace\` command."
          return 1
        fi
        command_args+=("$1")
        shift
        ;;
      *)
        if [[ $is_monorepo -eq 0 || parse_rest_as_command_args -eq 1 || -n "$workspace_package_name" ]]; then
          command_args+=("$1")
        else
          workspace_package_name="$1"
        fi
        shift
        ;;
    esac
  done

  if [[ $is_monorepo -eq 0 ]]; then
    yarn jest "${command_args[@]}" --verbose=false --no-coverage
  else
    if [[ -z $workspace_package_name ]]; then
      workspace_package_names="$(yarn workspaces list --json | jq --slurp --raw-output 'map(.name) | .[]')"
      echo "ERROR: Missing workspace package name. Possible package names are:"
      echo
      echo "$workspace_package_names"
      echo
      return 1
    fi

    if [[ $verbose -eq 1 ]]; then
      NODE_OPTIONS=--experimental-vm-modules yarn workspace "$workspace_package_name" exec jest "${command_args[@]}" --no-coverage
    else
      NODE_OPTIONS=--experimental-vm-modules yarn workspace "$workspace_package_name" exec jest "${command_args[@]}" --verbose=false --no-coverage
    fi
  fi
}

jfv() {
  jf "$@" --verbose
}

jfw() {
  jf "$@" -- --watch
}

jfvw() {
  jf "$@" --verbose -- --watch
}
# In case we fat-finger the command
alias jfwv jfvw

yw() {
  local command="workspace"
  if [[ $1 == "focus" || $1 == "foreach" || $1 == "list" ]]; then
    command="workspaces"
  fi

  yarn $command "$@"
}

ywa() {
  yarn workspaces foreach --all --no-private --parallel --verbose "$@"
}

ywd() {
  yw "$1" run since-latest-release -- diff
}

ywdh() {
  yw "$1" run since-latest-release --include-head -- diff
}

real_tinty_path="$(which tinty)"

# This is a wrapper around tinty that manually runs hooks.
#
# The reason we do this is that tinty seems to run hooks asynchronously,
# so the prompt is shown immediately, and then the output from the hooks,
# which looks strange.
#
# Maybe this is a quirk of zsh or something, but either way, we get around this
# by executing the hooks ourselves.
#
function tinty() {
  if [[ -n "$real_tinty_path" ]]; then
    case "$1" in
      apply)
        ~/.tinty/apply-colorscheme.sh "$real_tinty_path" "$2"
        ;;
      *)
        $real_tinty_path "$@"
    esac
  else
    echo "ERROR: tinty is not installed"
  fi
}
