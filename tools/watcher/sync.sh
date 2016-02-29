#!/bin/sh

echo "* Sync files from ${APP_SOURCE} to ${PROJECT_ROOT}"
if ! which rsync > /dev/null; then
    echo "*! rsync is not installed"
    exit 1
fi

if [ -d "${PROJECT_ROOT}" ]; then
    echo "* Sync changes ${APP_SOURCE} to ${PROJECT_ROOT}"
    rsync -rpDzh --exclude=".git*" --exclude="*node_modules/*" "${APP_SOURCE}/" "${PROJECT_ROOT}"
else
    echo "*! ${PROJECT_ROOT} do not exist or not a directory"
fi
exit $?