#!/usr/bin/env bash


set -eo pipefail


function user_units {
    systemctl list-unit-files --user --no-pager --type=service --no-legend | awk '{print "user " $1}'
}

function system_units {
    systemctl list-unit-files --no-pager --type=service --no-legend | awk '{print "system " $1}'
}
dir="~/.config/rofi"
units=$(user_units; system_units)

line=$(rofi -theme $dir/servicemanager.rasi -dmenu "$@" <<<$units )
session=$(echo $line | cut -f1 -d ' ')
unit=$(echo $line | cut -f2 -d ' ')

commands="start
stop
restart
enable
disable"

cmd=$(rofi -theme $dir/servicemanager.rasi -dmenu "$@" <<<"${commands[@]}")
function ctl {
    if [[ "$session" == "system" ]]; then
        sudo -A systemctl "$@"
    else
        systemctl --user "$@"
    fi
    if [ "$unit" == "bluetooth.service" ] && [ "$cmd" == "start" ]; then
        exec blueman-applet &
    fi
}

result=$(ctl "$cmd" "$unit")
notify-send "Service $unit: $cmd"
# rofi -dmenu "$result"
