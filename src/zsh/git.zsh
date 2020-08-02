# hubba hubba
eval "$(hub alias -s)"

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

# Load the Bash Git completion script manually
# (The zsh version is in src/zsh/autoload/_git, and this line comes from there)
zstyle ':completion:*:*:git:*' script ~/.git-completion.sh

# vi: ft=sh
