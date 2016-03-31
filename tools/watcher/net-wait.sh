#!/bin/sh

TOOLS_DIR=$(dirname $(dirname $(readlink -m $0)))
WAIT_CMD="${TOOLS_DIR}/wait-for-it/wait-for-it.sh"

HOST=$1
PORT=$2

if [ "${HOST}" = "" ] || [ "${PORT}" = "" ]; then
    echo "Please provide HOST and PORT to check."
    exit 1
fi


${WAIT_CMD} -h ${HOST} -p ${PORT} -t ${NET_WAIT_TIMEOUT} || exit 2

exit 0
