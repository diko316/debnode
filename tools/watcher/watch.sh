#!/bin/sh

FILE=$1
ACTION=$2

if ! which inotifywait > /dev/null; then
    echo "*! inotify-tools is not installed" >&2
    exit 1
fi

if [ ! "$ACTION" ]; then
    echo "*! no action defined" >&2
    exit 1
fi

trap kill_inotify 0
trap kill_inotify 1
trap kill_inotify 2
trap kill_inotify 3
trap kill_inotify 6
trap kill_inotify 15

kill_inotify() {
    if [ "${APID}" ]; then
        ls /proc | grep '^'${APID}'$' && kill ${APID}
    fi
    
    if [ "${PID}" ]; then
        ls /proc | grep '^'${PID}'$' && kill ${PID}
    fi
    exit 0
}

while true; do
    if [ -x "${FILE}" ]; then
        ${ACTION} &
        APID=$!
        sleep 5
        ls /proc | grep '^'${APID}'$' || exit 1
        
        if [ -d "${FILE}" ]; then
            inotifywait -q -r -e close_write,modify,move,create,delete "${FILE}" &
        else
            inotifywait -q -e close_write,modify,move,create,delete "${FILE}" &
        fi
        PID=$!
        wait $PID
        ls /proc | grep '^'${APID}'$' && kill ${APID}
        ls /proc | grep '^'${PID}'$' && kill ${PID}
        
    else
        break
    fi
done

exit 0
