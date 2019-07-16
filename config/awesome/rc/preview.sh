#!/bin/sh

#Xephyr -ac -br -noreset -screen $resolution $display &
#xephyr_pid=$!
#sleep 1
#DISPLAY=$display awesome -c $awesome_config
#kill $xephyr_pid


#resolution=800x600
resolution=1024x768
display=:1
rc=${1:-rc.lua}
config=~/.config/awesome/rc/$rc

Xephyr -ac -br -noreset -screen $resolution $display &
sleep 1
DISPLAY=$display awesome -c $config
