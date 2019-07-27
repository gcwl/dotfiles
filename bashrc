#
# ~/.bashrc
#


# If not running interactively, dont do anything
[[ $- != *i* ]] && return


# disable START/STOP signals, see man stty
# i.e. disable ctrl-s freeze
stty -ixon


#PS1="[\u@\h \W]${bldwht}\$?${txtrst} "
export PS1="[\u@\h \W]\$? "


# editor
export EDITOR='vim'
alias vi='vim'


# web browser
export BROWSER='no_default_browser'


# pager
export PAGER='less'
alias less='less -ir'   # case insensitive when search
alias l='less'


# bash history
# https://superuser.com/questions/308882/secured-bash-history-usage#308892
# histappend tells bash to append the last $HISTSIZE lines to the $HISTFILE
# file when an interactive shell exits.
shopt -s histappend
# http://www.linuxjournal.com/content/using-bash-history-more-efficiently-histcontrol
# The ignorespace flag tells bash to ignore commands that start with spaces.
# The other flag, ignoredups, tells bash to ignore duplicates.
# You can concatenate and separate the values with a colon, ignorespace:ignoredups,
# if you wish to specify both values, or you can just specify ignoreboth.
readonly HISTCONTROL=ignoreboth
readonly HISTTIMEFORMAT='%F %T '
readonly HISTFILE
readonly HISTFILESIZE
readonly HISTSIZE=90000
readonly HISTCMD
readonly HISTIGNORE
# PROMPT_COMMAND executes the given command prior to issuing each prompt.
# history -a appends the command typed just before the current one to
# $HISTFILE.
readonly PROMPT_COMMAND="history -a"
alias his='history'
alias hist='history | tail -100'
nohist () { export HISTFILE=/dev/null; }    # dont track history for this session after this command


# petar marinov, http:/geocities.com/h2428, this is public domain
# http://linuxgazette.net/109/marinov.html
cd_func ()
{
  local newdir tmpdir nth

  newdir=${1:-$HOME}

  # case 1: cd --
  if [[ "$!" == "--" ]]; then
    dirs -v
    return 0
  fi

  # case 2: cd -n
  if [[ "${newdir:0:1}" == "-" ]]; then
    nth=${newdir:1} # substr starting at position 1
    nth=${nth:-1}   # default to 1
    newdirs=$(dirs +${nth})
    [[ -z $newdir ]] && return 1
  fi

  # case 3: cd path/to/dir
  newdir=${newdir/#\~/$HOME}
  pushd ${newdir} >/dev/null
  [[ $? -ne 0 ]] && return 1

  # keep hist-list short (max length at 20)
  popd -n +20 > /dev/null 2>&1

  # remove dups from hist-list
  for i in $(seq $(dirs -v | wc -l) -1 0); do
    tmpdir=$(dirs +$i 2>/dev/null)
    [[ -z $tmpdir ]] && continue || tmpdir=${tmpdir/#\~/$HOME}
    [[ "$tmpdir" == "$newdir" ]] && popd -n $i >/dev/null 2&>1
  done

  return 0
}
alias cd=cd_func
alias -- --='cd_func --'            # list past 10 cd history


# cd
alias -- -='cd -'
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'


# ls
# alias ls='ls -hF --time-style="+%Y.%m.%d-%H:%M:%S" --color=auto --group-directories-first'
alias ls='ls -hF --time-style="+%F %T" --color=auto --group-directories-first'
alias lsl='ls -l'
alias lr='ls -R'
alias la='ls -A'
alias ll='ls -lA'
alias lx='ll -BX'           # sort by extension
alias lz='ll -rS'           # sort by size
alias lt='ll -rt'           # sort by modification time
alias lu='lt -u'            # sort by access time


# safety features
alias rm='rm -div'
alias cp='cp -ipv'
alias mv='mv -iv'
alias ln='ln -iv'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'


# see which man page
which () { (alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@; }
export -f which


alias sudo='sudo '              # so that sudo works with aliases
alias dmesg='dmesg --human'
alias mkdir='mkdir -p -v'
alias grep='grep --color=auto -i'
alias g='grep'
alias b='echo -en "\n\n\n\n\n"' # blank lines


alias xmount='sudo mount -o uid=$(id -u),gid=$(id -g),file_mode=644,dir_mode=755'
alias fatmount='sudo mount -t vfat -o uid=$(id -u),gid=$(id -g),fmask=133,dmask=022'
alias umount='sudo umount'


#alias lsusb=
alias lsfs='lsblk --fs'


# perl-rename, see ... $ man perl-rename
alias rename='/usr/bin/perl-rename --dry-run --verbose'
alias rename4real='/usr/bin/perl-rename --verbose'


# journalctl
alias lsboots='/usr/bin/journalctl --no-pager --list-boots'
alias journal='/usr/bin/journalctl -b --reverse --catalog --priority notice'


# # find
# f ()  { find -iname "*$1*"; }            # find $1 in basename
# f1 () { find -maxdepth 1 -iname "*$1*"; }
# f2 () { find -maxdepth 2 -iname "*$1*"; }
# f3 () { find -maxdepth 3 -iname "*$1*"; }


# locate
alias locate='/usr/bin/locate -i'
loc () {    # restrict locate within homedir
  local pattern="^${HOME}/.*${1}.*"
  /usr/bin/locate --ignore-case --regex $pattern
}


# fix directory or files permission
fixperm () {
  if [ -d $1 ]; then
    find $1 -type d -exec chmod 755 {} \;
    find $1 -type f -exec chmod 644 {} \;
  elif [ -f $1 ]; then
    chmod 644 $1
  else
    echo "fixperm failed."
  fi
}


# tar
qtar () { tar -cvf  "${1%%/}.tar"     "${1%%/}/"; }
qtbz () { tar -cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
#qtgz () { tar -cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
qtgz () {
  local fname=${1%%/}
  local fsize=$(/usr/bin/du -sb $fname | awk '{print $1}')
  tar -c ${fname}/ | pv -s $fsize | gzip > ${fname}.tar.gz
}
qtxz () {
  local fname=${1%%/}
  local fsize=$(/usr/bin/du -sb $fname | awk '{print $1}')
  tar -c ${fname}/ | pv -s $fsize | xz > ${fname}.tar.xz
}
# parallel tar
ptxz () {
  local fname=${1%%/}
  local fsize=$(/usr/bin/du -sb $fname | awk '{print $1}')
  tar -c ${fname}/ | pv -s $fsize | xz --threads=0 > ${fname}.tar.xz
}
ptgz () {
  local fname=${1%%/}
  local fsize=$(/usr/bin/du -sb $fname | awk '{print $1}')
  tar -c ${fname}/ | pv -s $fsize | pigz > ${fname}.tar.gz
}


# sources
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
[ -r ~/.dir_colors ] && eval $(dircolors -b ~/.dir_colors)
# source $HOME/.bash/colorman
source $HOME/.bash/aliases
source $HOME/.bash/exports
source $HOME/.bash/marks
source $HOME/.bash/fzf
source $HOME/.bash/xinit


# list tmux sessions when login
# if none, redirect stderr to /dev/null and then swallow non-zero exit code
tmux list-sessions 2>/dev/null || true

# vim: set ts=8 sw=2 tw=0 et ft=sh :
