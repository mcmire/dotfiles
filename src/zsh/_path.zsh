PATH=$HOME/.bin:$PATH

# Update the path that zsh uses to autoload function definitions
#
# Sources:
#
# * http://zsh.sourceforge.net/Doc/Release/Functions.html
# * https://raw.githubusercontent.com/git/git/fe8321ec057f9231c26c29b364721568e58040f7/contrib/completion/git-completion.zsh
#
fpath=(~/.zsh/autoload $fpath)
