#!/bin/sh

FILE=$1
ACTION=$2

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

kill_all() {
    if [ "${APID}" ]; then
        kill "${APID}"
        APID=
    fi
    if [ "${PID}" ]; then
        kill "${PID}"
        PID=
    fi
}

kill_inotify() {
    kill_all
    exit 0
}

while true; do
    if [ -x "${FILE}" ]; then
        echo "Calling action!"
        setsid ${ACTION} > /dev/null 2>&1 < /dev/null &
        APID=$!
        
        echo "Monitoring file change"
        if [ -d "${FILE}" ]; then
            inotifywait -q -r -e close_write,modify,move,create,delete "${FILE}" &
        else
            inotifywait -q -e close_write,modify,move,create,delete "${FILE}" &
        fi
        PID=$!
        wait
        kill_all
        
    else
        break
    fi
done

exit 0
