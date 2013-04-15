umask 027

case $OSTYPE in
    darwin*)
        export LSCOLORS="dxgxxxxxcx"
        alias ls="ls -hG"
        ;;
    *)
        alias ls="ls -h --color=auto --time-style=long-iso"
esac

shopt -s checkwinsize
shopt -s cmdhist
shopt -s histappend

stty -ixon

[[ $EUID -eq 0 ]] && COLOR=31 || COLOR=35
[[ $TMUX ]] && export TERM=screen-256color || export TERM=xterm-256color
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export PAGER=less
export JAVA_HOME="/opt/java/jre"
SYSPATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH="/opt/heroku-client:$JAVA_HOME/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$HOME/.bin:$HOME/.usr/bin:$HOME/.rbenv/bin:$SYSPATH"
export LD_LIBRARY_PATH=$HOME/.usr/lib:$JAVA_HOME/lib/amd64
export PS1='\[\e[1;30;${COLOR}m\]\h\[\e[1;33m\]${TMUX:+*}\[\e[0m\] \[\e[1;34m\]${PWD##*/}\[\e[0m\] '
export LS_COLORS="di=01;33:"
export PROMPT_COMMAND="history -a"
export LANG="en_US.UTF-8"
export EDITOR=vim
export BROWSER=firefox
export DMENU_OPTIONS="-h 22 -fn -*-dina-bold-r-normal--*-*-*-*-*-*-*-* -i -b -sf #9e5641 -sb #000 -nb #000 -nf #aaa"
export XDG_CONFIG_HOME=$HOME/.xdg/config
export XDG_DATA_HOME=$HOME/.xdg/data

source /usr/share/chruby/chruby.sh

alias vim="vim -X -u $HOME/.vimrc"
alias bashrc="vim $HOME/.bashrc"
alias vimrc="vim $HOME/.vimrc"
alias rc="source $HOME/.bashrc"
alias mkdir="mkdir -p"
alias free="free -m"
alias lsa="ls -A"
alias l="ls -1"
alias la="ls -1A"
alias ll="ls -l"
alias lla="ls -lA"
alias ltr="ls -ltr"
alias df="df -h"
alias du="du -h"
alias ..="cd .."
alias sudo="sudo -E"
alias sd="sudo -s"
alias c="clear"
alias j="jobs"
alias grep="grep --color=auto"
alias pacin="sudo pacman -S"
alias pacun="sudo pacman -R"
alias pacups="sudo pacman -Syu"
alias pacup="sudo pacman -Su"
alias pacor="pacman -Qtdq"
alias pacro="pacor | xargs sudo pacman -R --noconfirm"
alias pacsr="pacman -Ss"
alias x="xinit"
alias d="date +'%a %F %H:%M'"
alias gc="git commit -m"
alias ga="git add"
alias gap="git add -p"
alias gs="git status -s"
alias gls="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gp="git push"
alias gup="git pull --recurse-submodules"
alias t="tmux"
alias ta="tmux a"
alias aur="cd $HOME/source/aur"
alias anki="anki -b $HOME/.anki"
alias pd="pushd"
alias genc="ctags -R . && cscope -Rbq"
