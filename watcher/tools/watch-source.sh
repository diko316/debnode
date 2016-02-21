#!/bin/sh

WATCH=$(which watch)
PID=${LOG_FILES}/run.pid

if [ -f "${PID}" ]; then
    PROCESS_ID=$(cat ${PID})
    if ! kill "${PROCESS_ID}"; then
        kill -9 "${PROCESS_ID}" || exit 1
    fi
    rm "${PID}"
fi

PID=${LOG_FILES}/watch-source.pid

if [ -f "${PID}" ]; then
    PROCESS_ID=$(cat ${PID})
    if ! kill "${PROCESS_ID}"; then
        kill -9 "${PROCESS_ID}" || exit 1
    fi
    rm "${PID}"
fi

if [ -d "${APP_SOURCE}" ]; then
    echo "Running watch on source file change..."
    setsid ${WATCH} "${APP_TOOLS}/on-source-change.sh" "${APP_SOURCE}" > "${LOG_FILES}/watch.log" 2>&1 < /dev/null &
    echo $! > "${PID}"
    
fi


if [ -d "${PROJECT_ROOT}" ]; then
    echo "Running Watch on app runner..."
    #setsid ${WATCH} "${APP_TOOLS}/on-project-change.sh" "${PROJECT_ROOT}" > "${LOG_FILES}/change.log" 2>&1 < /dev/null &
    
    "${APP_TOOLS}/on-project-change.sh" &
    ${WATCH} "${APP_TOOLS}/on-project-change.sh" "${PROJECT_ROOT}"
    
else
    "${APP_TOOLS}/on-project-change.sh"
fi



