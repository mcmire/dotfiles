# This is mostly based on:
#
# * <https://github.com/agkozak/agkozak-zsh-prompt>
#
# For help on how prompts work, especially the special %-codes, read:
#
# * <http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html>
# * <http://web.archive.org/web/20171121014222/https://www-s.acm.illinois.edu/workshops/zsh/prompt/escapes.html>
#
# For help on how colors work, read:
#
# * <https://github.com/zsh-users/zsh/blob/master/Functions/Misc/colors>
# * <https://wiki.archlinux.org/index.php/zsh#Customizing_the_prompt>
# * <https://wiki.archlinux.org/index.php/zsh#Colors>

autoload -Uz colors add-zle-hook-widget add-zsh-hook

# Enable colors
colors

lastwd=''

# Redraw prompt when terminal size changes
TRAPWINCH() {
  zle && zle -R
}

read-version() {
  local current_version exitstatus
  current_version=$(asdf current "$1" --no-header | awk '{ print $2 }')
  exitstatus=$?

  if [[ $exitstatus -eq 1 ]]; then
    echo "?.?.?"
  elif [[ -n $current_version ]]; then
    echo "$current_version" | sed -Ee 's/[ ]+.+$//'
  fi
}

update-version() {
  local language="$1"
  local index="$2"
  local current_version="$3"

  if [[ -n $current_version ]]; then
    psvar[$index]="$language $current_version"
  else
    psvar[$index]=''
  fi

  zle && { zle .reset-prompt; zle -R; }
}

# Redraw prompt when switching modes
zle::keymap-select() {
  zle && { zle .reset-prompt; zle -R; }
}

prompt::set() {
  prompt__time='%F{blue}%D{%-I:%M:%S %p}%f'
  prompt__hostname='%F{cyan}%n@%m%f'
  prompt__cwd='%F{green}%~%f'
  prompt__git_branch='%(1V. on %F{yellow}%1v%f.)'
  prompt__language_versions_separator='%(2V. using.%(3V. using.%(4V. using.)))'
  prompt__ruby_version='%(2V. %F{red}%2v%f.)'
  prompt__nodejs_version='%(3V.%(2V., . )%F{red}%3v%f.)'
  prompt__python_version='%(4V.%(2V., .%(3V., . ))%F{red}%4v%f.)'
  prompt__indicator='%# '
  newline=$'\n'

  PROMPT="[${prompt__time}] $prompt__hostname in ${prompt__cwd}${prompt__git_branch}${prompt__language_versions_separator}${prompt__ruby_version}${prompt__nodejs_version}${prompt__python_version}${newline}${prompt__indicator}"
}

job::read-git-status() {
  local ref branch

  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  case $? in        # See what the exit code is.
    0) ;;           # $ref contains the name of a checked-out branch.
    128) return ;;  # No Git repository here.
    # Otherwise, see if HEAD is in detached state.
    *) ref=$(command git rev-parse --short HEAD 2> /dev/null) || return ;;
  esac
  branch=${ref#refs/heads/}

  echo $branch
}

prompt::update-git-status() {
  psvar[1]="$3"
  zle && zle .reset-prompt
  async_stop_worker worker::update-git-status -n
}

job::read-ruby-version() {
  read-version ruby
}

prompt::update-ruby-version() {
  update-version ruby 2 "$3"
  async_stop_worker worker::update-ruby-version -n
}

job::read-nodejs-version() {
  read-version nodejs
}

prompt::update-nodejs-version() {
  update-version nodejs 3 "$3"
  async_stop_worker worker::update-nodejs-version -n
}

job::read-python-version() {
  read-version python
}

prompt::update-python-version() {
  update-version python 4 "$3"
  async_stop_worker worker::update-python-version -n
}

prompt::preexec() {
  executable=$(echo "$1" | sed -Ee 's/^([^ ]+).*$/\1/')

  if [[ $executable == "cd" ]]; then
    lastwd=$PWD
  fi
}

prompt::precmd() {
  local last_cmd=$(fc -ln -1)

  if [[ -z $lastwd || $lastwd != $PWD || $last_cmd == 'g' || $last_cmd =~ ^git( |$) || $last_cmd =~ ^gco || $last_cmd =~ ^gbm ]]; then
    psvar[1]=''
    psvar[2]=''
    psvar[3]=''
    psvar[4]=''

    prompt::set

    if type async_init &>/dev/null; then
      # Update git status
      async_start_worker worker::update-git-status -n
      async_register_callback worker::update-git-status prompt::update-git-status
      async_job worker::update-git-status job::read-git-status

      # Update Ruby version
      async_start_worker worker::update-ruby-version -n
      async_register_callback worker::update-ruby-version prompt::update-ruby-version
      async_job worker::update-ruby-version job::read-ruby-version

      # Update Node version
      async_start_worker worker::update-nodejs-version -n
      async_register_callback worker::update-nodejs-version prompt::update-nodejs-version
      async_job worker::update-nodejs-version job::read-nodejs-version

      # Update Python version
      async_start_worker worker::update-python-version -n
      async_register_callback worker::update-python-version prompt::update-python-version
      async_job worker::update-python-version job::read-python-version
    fi
  else
    prompt::set
  fi

  lastwd=$PWD
}

# Disable extra prompt features when running terminal in VSCode or VSCode
# derivatives like Cursor
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  prompt::set
else
  add-zsh-hook preexec prompt::preexec
  add-zsh-hook precmd prompt::precmd
fi
