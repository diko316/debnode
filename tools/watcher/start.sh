#!/bin/sh

TOOLS_DIR=$(dirname $(readlink -m $0))

##########################################
# sync product root with source files
##########################################
${TOOLS_DIR}/sync.sh

##########################################
# sync product root with when source files
#    is updated
##########################################
${TOOLS_DIR}/watch-source.sh


##########################################
# use APP_RUNNER if found and executable
##########################################
if [ ! -f "${APP_RUNNER}" ]; then
    echo "! Runner not found" >&2
    exit 1
fi

if [ ! -x "${APP_RUNNER}" ]; then
    echo "! Runner is not executable" >&2
    exit 1
fi

if [ ! -r "${APP_OBSERVE}" ]; then
    echo "! Unable to find observe path" >&2
    exit 1
fi


${TOOLS_DIR}/watch.sh ${APP_OBSERVE} ${APP_RUNNER}

exit 0


##########################################
# watch sample:
#     run $PROJECT_ROOT/sample-runner.sh
#       when $PROJECT_ROOT/* is updated
##########################################
#ACTION="${PROJECT_ROOT}/sample-runner.sh"
#OBSERVE="${PROJECT_ROOT}"

#echo "Watching... ${OBSERVE}"
#${TOOLS_DIR}/watch.sh ${OBSERVE} ${ACTION}

