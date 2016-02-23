#!/bin/sh

WATCH=$(which watch)
SOURCE_PID=${LOG_FILES}/source_change.pid
WATCH_PID=${LOG_FILES}/watch-source.pid
TAIL_LOG=$1

# kill source change pid
if [ -f "${SOURCE_PID}" ]; then
    PROCESS_ID=$(cat ${SOURCE_PID})
    if ! kill "${PROCESS_ID}"; then
        kill -9 "${PROCESS_ID}" || exit 1
    fi
    rm "${SOURCE_PID}"
fi

# kill watch pid
if [ -f "${WATCH_PID}" ]; then
    PROCESS_ID=$(cat ${WATCH_PID})
    if ! kill "${PROCESS_ID}"; then
        kill -9 "${PROCESS_ID}" || exit 1
    fi
    rm "${WATCH_PID}"
fi

if [ -d "${APP_SOURCE}" ]; then
    echo "Running watch on source file change... ${APP_SOURCE}"
    setsid ${WATCH} "${APP_TOOLS}/on-source-change.sh" "${APP_SOURCE}" > "${LOG_FILES}/watch.log" 2>&1 < /dev/null &
    echo $! > "${SOURCE_PID}"
    
fi


if [ ! -d "${PROJECT_ROOT}" ]; then
    mkdir -p "${PROJECT_ROOT}"
fi
    
echo "Running Watch on app runner... ${PROJECT_ROOT}"
setsid ${WATCH} "${APP_TOOLS}/on-project-change.sh" "${PROJECT_ROOT}" > "${LOG_FILES}/change.log" 2>&1 < /dev/null &
echo $! > "${WATCH_PID}"

# sync to simulate project change
"${APP_TOOLS}/on-source-change.sh"
    

if [ "${TAIL_LOG}" = "-t" ]; then
    tail -f "${LOG_FILES}/change.log"
fi

