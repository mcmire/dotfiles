if [ -f /etc/zshrc ]; then
  echo "
It looks like macOS's default /etc/zshrc exists. The dotfiles you're using
overrides PATH, and /etc/zshrc interferes. Make sure to remove it before
continuing."
fi

if [ -f /etc/zprofile ]; then
  echo "
It looks like macOS's default /etc/zprofile exists. The dotfiles you're using
overrides PATH, and /etc/zprofile interferes. Make sure to remove it before
continuing."
fi

# Set a sensible default PATH:
#
# * /usr/local/bin is where Homebrew used to keep executables (before Apple
#   Silicon) — eventually this will be removed but keeping it here for compat
# * ~/.bin is where we can keep our own custom executables
#
# Why do we totally reset the PATH here instead of prepending to it? Because of
# tmux. tmux inherits from the parent shell's PATH. The parent shell has already
# loaded this file, but tmux will load it all over again. Therefore if we simply
# prepend, then PATH will explode and have a bunch of duplicates it. This causes
# issues with NVM such as this one[1] and nodenv as well.
#
# [1]: https://github.com/creationix/nvm/issues/1652>
#
if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  export PATH=$HOME/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
fi

# Set a sensible default MANPATH as well
if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  export MANPATH=/usr/share/man
fi

# Update the path that zsh uses to autoload function definitions
#
# Sources:
#
# * http://zsh.sourceforge.net/Doc/Release/Functions.html
# * https://raw.githubusercontent.com/git/git/fe8321ec057f9231c26c29b364721568e58040f7/contrib/completion/git-completion.zsh
#
if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  fpath=(~/.zsh/autoload $fpath)
fi
