#!/bin/sh

TOOLS_DIR=$(dirname $(readlink -m $0))


##########################################
# sync product root with when source files
#    is updated
##########################################
${TOOLS_DIR}/watch-source.sh


##########################################
# watch sample:
#     run $PROJECT_ROOT/sample-runner.sh
#       when $PROJECT_ROOT/* is updated
##########################################
ACTION="${PROJECT_ROOT}/sample-runner.sh"
OBSERVE="${PROJECT_ROOT}"

echo "Watching... ${OBSERVE}"
${TOOLS_DIR}/watch.sh ${OBSERVE} ${ACTION}

