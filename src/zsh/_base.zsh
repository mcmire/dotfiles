# Recognize use of variables in the PROMPT environment variable and replace them
setopt prompt_subst

# Enable completion
autoload -U compinit && compinit

# Disable autocorrection
unsetopt correct_all

# Do not share history across multiple instances of the shell
unsetopt share_history
unsetopt append_history
unsetopt inc_append_history

# vi: ft=sh
