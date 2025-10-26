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
alias o=open-project
alias nvim-next="NVIM_APPNAME=nvim-next nvim"

#== Bundle ==

alias b="bundle"
alias be="b exec"
alias r="be rspec"
alias ba="b && be appraisal install"

#== Git ==

# Checking out
alias gco="git checkout"
alias gcob="gco --branch"

# Adding
alias ga="g add -A"
alias gA="g add -A ."

# Removing
alias grm="g rm"

# Committing
alias gc="g commit --verbose --no-verify"
alias gcm="gc --message"
alias gca="gc --amend"
alias gcan="gc --amend --no-edit"

# Pulling
alias gp="g pull"
alias gpr="gP --rebase"

# Pushing
alias gP="g push"
alias gPf="gp --force"

# Resetting
alias gR="g reset --hard"
alias gRhu="gR HEAD~"
alias grhu="g reset HEAD~"

# Branches
alias gb="g branch"
alias gbr="git branches"
alias gbd="git delete-branch-and-remote"
alias gbm="gb --move --force"

# Diffing
alias gd="git diff"
alias gdc="gd --cached"

# Logging
alias gl="g log"

# Cherry picking
alias gcp="git cherry-pick"

# Merging
alias gm="g merge --ff-only"
alias gma="g merge --abort"
alias gmc="g merge --continue"

# Rebasing
alias gr="g rebase"
alias gra="gr --abort"
alias grc="gr --continue"
alias gri="gr --interactive"
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

#== tmux ==

alias tk="tmux kill-session"

#== Overriding existing executables ==

# For some reason, Tig does not show colors when `tmux-256color` is used as the
# value of `TERM`. It might be that we don't have to use this anymore, or that
# we have to adjust `tmux-256color`.
# See: <https://github.com/jonas/tig/issues/1210>
alias tig="TERM=xterm-256color tig"
