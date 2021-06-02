#!/usr/bin/env bash


set -eo pipefail


function user_units {
    systemctl list-unit-files --user --no-pager --type=service --no-legend | awk '{print "user " $0}'
}

function system_units {
    systemctl list-unit-files --no-pager --type=service --no-legend | awk '{print "system " $0}'
}

units=$(user_units; system_units)

line=$(rofi -dmenu "$@" <<<$units )
session=$(echo $line | cut -f1 -d ' ')
unit=$(echo $line | cut -f2 -d ' ')

commands="
status
start
stop
restart
kill
reload
reload-or-restart
enable
disable
cancel
reset-failed
isolate
condreload
revert
condrestart
edit
exit
force-reload
mask
reenable
"

cmd=$(rofi -dmenu "$@" <<<"${commands[@]}")
echo $cmd
echo $unit
function ctl {
    if [[ "$session" == "system" ]]; then
        sudo -A systemctl "$@"
    else
        systemctl --user "$@"
    fi
}

result=$(ctl "$cmd" "$unit")
notify-send $result
# rofi -dmenu "$result"