#!/bin/sh

WATCH=$(which watch)

if [ -d "${APP_SOURCE}" ]; then
    echo "Running watch on source file change..."
    setsid ${WATCH} "${APP_TOOLS}/on-source-change.sh" "${APP_SOURCE}" > "${LOG_FILES}/watch.log" 2>&1 < /dev/null &
fi

if [ -d "${PROJECT_ROOT}" ]; then
    echo "Running Watch on app runner..."
    setsid ${WATCH} "${APP_TOOLS}/on-project-change.sh" "${PROJECT_ROOT}" > "${LOG_FILES}/change.log" 2>&1 < /dev/null &
fi

"${APP_TOOLS}/on-project-change.sh"

