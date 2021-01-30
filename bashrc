#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Env Variables
export PATH=$PATH:~/bin:~/.cargo/bin
export VISUAL=vim
export EDITOR=$VISUAL

# aliases
alias ls='ls --color=auto'
alias la='ls -la'

PS1='\[\e[1;37m\][\[\e[1;31m\]\u\[\e[1;37m\]@\[\e[1;34m\]\h \W\[\e[1;37m\]]\$\[\e[m\] '
# color reference:
#   Foreground      Background
#       
#   Black: 30       40
#   Blue: 34        44
#   Cyan: 36        46
#   Green: 32       42
#   Purple: 35      45
#   Red: 31         41
#   White: 37       47
#   Yellow: 33      43


