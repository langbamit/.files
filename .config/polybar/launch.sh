#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done


polybar top-right &
polybar top-center &
polybar top-left &

# sleep 1 && echo "jskdlksldksldks"
# sleep 5 && xdo below -t $(xwininfo -root -children  | egrep -o "^ +.x[^ ]+" | tail -1 | tr -d " ") $(xdo id -n polybar)
sleep 5 && xdo below -t $(xwininfo -root -children  | egrep -o "^ +.x[^ ]+" | tail -1 | tr -d " ") $(xdo id -n polybar; xdo id -n tray)

echo "Bars launched..."