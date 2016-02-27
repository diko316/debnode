#!/bin/sh

FILE=$1
ACTION=$2
PID=$!

if ! which inotifywait > /dev/null; then
    echo "! inotify-tools is not installed" >&2
    exit 1
fi

if [ ! "$ACTION" ]; then
    echo "! no action defined" >&2
    exit 1
fi

trap kill_inotify 0
trap kill_inotify 1
trap kill_inotify 2
trap kill_inotify 3
trap kill_inotify 6
trap kill_inotify 15

kill_inotify() {
    if [ "${PID}" ]; then
        kill "${PID}"
    fi
    exit 0
}

while true; do
    if [ -x "${FILE}" ]; then
        if [ -d "${FILE}" ]; then
            inotifywait -q -r -e close_write,modify,move,create,delete "${FILE}" &
        else
            inotifywait -q -e close_write,modify,move,create,delete "${FILE}" &
        fi
        PID=$!
        wait
        
        if ! eval "${ACTION}"; then
            exit 3
        fi
        
    else
        break
    fi
done

exit 0
