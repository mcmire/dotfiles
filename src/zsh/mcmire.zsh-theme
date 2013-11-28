# This is mostly based on:
# <http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/>
#
# For help on how prompts work, read:
# <http://www.acm.uiuc.edu/workshops/zsh/prompt/escapes.html>
#
# For help on how colors work, read:
# <https://wiki.archlinux.org/index.php/zsh#Customizing_the_prompt>

function Color {
  echo -ne "\e[${1};1m${2}\e[0m"
}

function Color__red {
  echo "$(Color 31 "$1")"
}

function Color__green {
  echo "$(Color 32 "$1")"
}

function Color__yellow {
  echo "$(Color 33 "$1")"
}

function Color__blue {
  echo "$(Color 34 "$1")"
}

function Color__magenta {
  echo "$(Color 35 "$1")"
}

function Color__cyan {
  echo "$(Color 36 "$1")"
}

function Prompt__Fragment__collapsed_pwd {
  echo "${PWD/#$HOME/~}"
}

function Prompt__Fragment__username {
  echo -n '%n'
}

function Prompt__Fragment__host {
  echo -n '%m'
}

function Prompt__Fragment__rbenv_info {
  local out="$(rbenv version | sed -e 's/ (set.*$//')"

  local gemsets="$(rbenv gemset active 2>/dev/null | perl -ne 'print join(", ", split(" ")) . "\n"')"
  if [[ -n $gemsets ]]; then
    out+=" (gemsets: $gemsets)"
  fi

  echo -n "$out"
}

function Prompt__Fragment__rc_char {
  local char=""
  if git branch >/dev/null 2>/dev/null; then
    char='±'
  else
    char='○'
  fi
  echo -n "$char"
}

function Prompt__rvm_prompt_path {
  echo -n "$(which rvm-prompt &>/dev/null)"
}

function Prompt__rbenv_path {
  echo -n "$(which rbenv &>/dev/null)"
}

function Prompt__username_fragment {
  echo -n "$(Color__magenta "$(Prompt__Fragment__username)")"
}

function Prompt__host_fragment {
  echo -n " on $(Color__yellow "$(Prompt__Fragment__host)")"
}

function Prompt__rbenv_info_fragment {
  local rbenv_info="$(Prompt__Fragment__rbenv_info)"
  if [[ -n $rbenv_info ]]; then
    echo -n " using $(Color__red "$rbenv_info")"
  fi
}

function Prompt__cwd_fragment {
  echo -n " at $(Color__green "$(Prompt__Fragment__collapsed_pwd)")"
}

function Prompt__rc_char_fragment {
  echo -n "$(Prompt__Fragment__rc_char) "
}

function Prompt__value {
  echo -n '$(Prompt__username_fragment)'
  echo -n '$(Prompt__host_fragment)'
  echo -n '$(Prompt__cwd_fragment)'
  echo -n '$(Prompt__rbenv_info_fragment)'
  echo -n "\n"
  echo '$(Prompt__rc_char_fragment)'
}

PROMPT="$(Prompt__value)"

# vi: ft=sh
