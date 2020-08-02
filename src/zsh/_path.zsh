# Set a sensible default PATH:
#
# * /usr/local/bin is where Homebrew puts executables
# * ~/.bin is where we will keep custom executables
#
# Why do we totally reset the PATH here instead of prepending to it? Because of
# tmux. tmux inherits from the parent shell's PATH. The parent shell has already
# loaded this file, but tmux will load it all over again. Therefore if we simply
# prepend, then PATH will explode and have a bunch of duplicates it. This causes
# issues with NVM such as this one
# (<https://github.com/creationix/nvm/issues/1652>)
# and nodenv as well.
export PATH=$HOME/.bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

# Set a sensible default MANPATH as well
export MANPATH=/usr/local/share/man:/opt/man:/opt/share/man:/usr/share/man

# Update the path that zsh uses to autoload function definitions
#
# Sources:
#
# * http://zsh.sourceforge.net/Doc/Release/Functions.html
# * https://raw.githubusercontent.com/git/git/fe8321ec057f9231c26c29b364721568e58040f7/contrib/completion/git-completion.zsh
#
fpath=(~/.zsh/autoload $fpath)
