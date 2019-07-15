#!/bin/sh
#
# ~/.xinitrc
#

##
## merge in defaults and keymaps
##
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

##
## start some nice programs
##
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

##
## keyboard and mouse rate
##
xset r rate 200 55
xset m 1/1 0

## https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg#Using_setxkbmap
# To see current XKB settings:
# $ setxkbmap -print -verbose 10
# To get a list of key combinations
# $ grep "grp:.*toggle" /usr/share/X11/xkb/rules/base.lst
#setxkbmap -layout "us, dvorak" -option "grp:menu_toggle"
#setxkbmap -layout "us, dvorak" -option "grp:ctrls_toggle"

##
## window manager
##
exec ${X_WM_EXEC:-awesome}
