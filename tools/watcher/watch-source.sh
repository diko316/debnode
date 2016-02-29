#!/bin/sh

TOOLS_DIR=$(dirname $(readlink -m $0))
WATCHER="${TOOLS_DIR}/watch.sh"
SYNC_ACTION="${TOOLS_DIR}/sync.sh"
SOURCE="${APP_SOURCE}"
TARGET="${PROJECT_ROOT}"
WATCHLOG="${LOG_FILES}/watch-source.log"
PIDFILE="${LOG_FILES}/watch-source.pid"


##########################
# check if source exists
#   and readable
##########################
if [ ! -r "${SOURCE}" ]; then
    echo "! ${SOURCE} do not exist or no read permission" >&2
    exit 1
fi


##########################
# check if target exists
#   and writable
##########################
if [ ! -w "${TARGET}" ]; then
    echo "! ${TARGET} do not exist or no write permission" >&2
    exit 1
fi

##########################
# remove pid if file exists
##########################
if [ -f "${PIDFILE}" ]; then
    kill $(cat "${PIDFILE}")
    rm -f "${PIDFILE}"
fi


##########################
# watch source
##########################
# try first if it succeeds
#if ! "${SYNC_ACTION}"; then
#    echo "! There errors running sync action" >&2
#    exit 1
#fi

echo "Watching ${SOURCE}"
setsid "${WATCHER}" "${SOURCE}" "${SYNC_ACTION}" > "${WATCHLOG}" 2>&1 < /dev/null &
echo $! > ${PIDFILE}
echo "Waiting for files to be partially synced"
echo "Observing ${SOURCE} $!"
while [ $(wc -L ${WATCHLOG} | cut -d' ' -f1) -lt 1 ]; do
    echo "..."
    sleep 1
done

