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

if [[ ${EUID} == 0 ]] ; then
        PROMPT='%B%F{yellow}%n%f%F{white} [%f%b%2~%B%F{white}] %f%b%0(?.%F{blue}.%F{red})%B%# > %f%b'
else
        PROMPT='%B%F{cyan}%n%f%F{white} [%f%b%2~%B%F{white}] %f%b%0(?.%F{blue}.%F{red})%B%# > %f%b'
fi
# Old bashrc file content
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Env Variables
#typeset -U PATH path
#path=("$HOME/bin" "$HOME/.cargo/bin" "$path[@]")
#export PATH
#export VISUAL=vim
#export EDITOR=$VISUAL
#export _JAVA_AWT_WM_NONREPARENTING=1

# aliases
alias ls='ls --color=auto'
alias la='ls -la'


