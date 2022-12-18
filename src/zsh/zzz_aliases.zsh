ALIASES_FILE="~/.zsh/zzz_aliases.zsh"
FUNCTIONS_FILE="~/.zsh/zzz_functions.zsh"

#== Managing aliases/functions ==

alias edit-aliases="v $ALIASES_FILE"
alias view-aliases="less $ALIASES_FILE"
alias edit-functions="v $FUNCTIONS_FILE"
alias view-functions="less $FUNCTIONS_FILE"
alias reload-env="source $ALIASES_FILE && source $FUNCTIONS_FILE"

#== Misc ==

alias is-running="ps aux | grep -v grep | grep"
alias olhc="open-latest-html-capture"
alias olic="open-latest-image-capture"
alias ll="ls -l"

#== Bundle ==

alias b="bundle"
alias be="b exec"
alias r="be rspec"
alias ba="b && be appraisal install"

#== Git ==

alias gA="g add -A ."
alias ga="g add -A"
alias gb="g branch"
alias gbd="git delete-branch-and-remote"
alias gbm="gb -M"
alias gc="g commit -v"
alias gca="gc --amend"
alias gcan="gc --amend --no-edit"
alias gcm="gc -m"
alias gco="git checkout"
alias gcb="gco -b"
alias gcp="git cherry-pick"
alias gd="git diff-base"
alias gdc="gd --cached"
alias gl="g log"
alias gm="g merge --ff-only"
alias gmc="g merge --continue"
alias gma="g merge --abort"
alias gp="g push"
alias gpf="gp --force"
alias gP="g pull"
alias gPr="gP --rebase"
alias gr="g rebase"
alias gR="g reset --hard"
alias gra="gr --abort"
alias grc="gr --continue"
alias grhu="g reset HEAD~"
alias gRhu="gR HEAD~"
alias gri="gr --interactive"
alias grm="g rm"
alias grs="gr --skip"

#== Zeus ==

alias z="zeus"
alias zR="zeus rails"
alias zr="zeus rspec"
alias zRm="sR db:migrate db:test:prepare"
alias zRmr="sR db:migrate:redo db:test:prepare"

#== Rails ==

alias R="rails"
alias Rc="R console"
alias Rm="R db:migrate db:test:prepare"
alias Rmr="R db:migrate:redo db:test:prepare"
alias Rr="R db:rollback"
alias Rrbm="R db:rollback_branch_migrations"

#== Overriding existing executables ==

# For some reason, Tig does not show colors when `tmux-256color` is used as the
# value of `TERM`. It might be that we don't have to use this anymore, or that
# we have to adjust `tmux-256color`.
# See: <https://github.com/jonas/tig/issues/1210>
alias tig="TERM=xterm-256color tig"
