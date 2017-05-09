# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rvallada/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# ------------------------------------------------------------------------------
# Begin .zshrc
# ------------------------------------------------------------------------------

# antigen ----------------------------------------------------------------------
source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme terminalparty

# Tell Antigen that you're done.
antigen apply


# aliases ----------------------------------------------------------------------

# Alias nvim to vim
alias vim=nvim


# exports ----------------------------------------------------------------------

# Editor
export EDITOR=nvim

# Go things
export GOPATH=~/.gowksp
export GOENV_ROOT=$HOME/.goenv
export PATH=$GOPATH/bin:$GOENV_ROOT/bin:$PATH

# ~/bin & ~/.local/share/bin
export PATH=~/bin:~/.local/share/bin:$PATH

# Ruby bin
export PATH=~/.gem/ruby/2.4.0/bin:$PATH

# evals ------------------------------------------------------------------------
eval "$(goenv init -)"

