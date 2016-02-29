#!/bin/sh

TOOLS_DIR=$(dirname $(readlink -m $0))


##########################################
# sync product root with source files,
#   then 
# sync product root with when source files
#    is updated
##########################################
${TOOLS_DIR}/sync.sh
${TOOLS_DIR}/watch-source.sh

##########################################
# use APP_RUNNER if found and executable
##########################################
echo "* Running app runner: ${APP_RUNNER}"
if [ ! -f "${APP_RUNNER}" ]; then
    echo "*! Runner not found" >&2
    exit 1
fi

if [ ! -x "${APP_RUNNER}" ]; then
    echo "*! Runner is not executable" >&2
    exit 1
fi

echo "* valid runner script ${APP_RUNNER}"

if [ ! -r "${APP_OBSERVE}" ]; then
    echo "*! Unable to find observe path" >&2
    exit 1
fi
echo "* valid observe path ${APP_OBSERVE}"


echo "* Watching: ${APP_OBSERVE}"
${TOOLS_DIR}/watch.sh "${APP_OBSERVE}" "${APP_RUNNER}"

exit 0

