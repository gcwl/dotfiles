#!/usr/bin/env sh

pgrep=/usr/bin/pgrep

run () {
  if ! $pgrep -x $1 &>/dev/null
  then
    $@
  fi
}

fork () {
  if ! $pgrep -x $1 &>/dev/null
  then
    $@ &
  fi
}

###

# redshift needs to be handle with special care
# when redshift-gtk exits (caused by exit of awesome)
# it will detach its child redshift and keep it running
# so we search for running process of redshift and kill it
if /usr/bin/pgrep -x redshift &>/dev/null
then
  pkill redshift
fi
# then start redshift-gtk
fork redshift-gtk

# autostart programs
#run xcomp -s
# fork parcellite
fork conky
# add more here ...
