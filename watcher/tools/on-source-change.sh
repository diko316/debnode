#!/bin/sh

if ! which rsync > /dev/null; then
    echo "rsync is not installed" >&2
    exit 1
fi


rsync -rpDzh --exclude=".git*" --exclude="*node_modules/*" "${APP_SOURCE}" "${PROJECT_ROOT}/"

exit $?
