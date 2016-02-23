#!/bin/sh

RERUN=${PROJECT_ROOT}/bin/run.sh
PID=${LOG_FILES}/source_change.pid

echo "* There are changes in ${APP_SOURCE}"

if [ -x "${APP_RUNNER}" ]; then
    RERUN="${APP_RUNNER}"
fi


if [ -x "${RERUN}" ]; then
    
    # kill running pid
    if [ -f "${PID}" ]; then
        PROCESS_ID=$(cat ${PID})
        echo "Killing old process ${PROCESS_ID}"
        if ! kill "${PROCESS_ID}"; then
            kill -9 "${PROCESS_ID}" || exit 1
        fi
    fi
    
    echo "* Running script: ${RERUN} "
    echo $$ > ${PID}
    eval ${RERUN}
    rm ${PID}
else
    echo "! Unable to find file or file is not executable: ${RERUN}"
    echo "    - to use run script, set the ENV variable APP_RUNNER to executable file"
fi


exit 0
