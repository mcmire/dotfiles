# hubba hubba
if type hub &>/dev/null; then
  eval "$(hub alias -s)"
fi

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]]; then
    source "$HOME/.hitch_export_authors"
  fi
}
alias unhitch='hitch -u'

# Load the Bash Git completion script manually
# (The zsh version is in /opt/homebrew/share/zsh/site-functions/_git, and this
# line comes from there)
if [[ -f ~/.git-completion.sh ]]; then
  zstyle ':completion:*:*:git:*' script ~/.git-completion.sh
fi
