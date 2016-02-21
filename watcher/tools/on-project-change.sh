#!/bin/sh

RERUN=${PROJECT_SOURCE}/bin/run.sh
PID=${LOG_FILES}/run.pid

if [ -x "${APP_RUNNER}" ]; then
    RERUN="${APP_RUNNER}"
fi


if [ -x "${RERUN}" ]; then
    
    # kill running pid
    if [ -f "${PID}" ]; then
        PROCESS_ID=$(cat ${PID})
        if ! kill "${PROCESS_ID}"; then
            kill -9 "${PROCESS_ID}" || exit 1
        fi
    fi
    
    echo $$ > ${PID}
    eval ${RERUN}
    rm ${PID}
    
fi


exit 0
