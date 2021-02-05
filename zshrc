# The following lines were added by compinstall
zstyle :compinstall filename '/home/franco/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install

PS1='%B%0(#.%F{124}.%F{blue})%1~ %#%b%f '
# Old bashrc file content
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Env Variables
typeset -U PATH path
path=("$HOME/bin" "$HOME/.cargo/bin" "$path[@]")
export PATH
export VISUAL=vim
export EDITOR=$VISUAL

# aliases
alias ls='ls --color=auto'
alias la='ls -la'


