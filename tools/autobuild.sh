#!/bin/sh

CURRENT_CWD=$(dirname $(readlink -m $0))
BUILDER="${CURRENT_CWD}/autobuild/${1}.sh"


if [ -f "${BUILDER}" ] && [ -x "${BUILDER}" ]; then
    ${BUILDER} || exit 1
else
    echo "No builder used, or builder not found: $1"
    echo "* Please use one of the builders below:"
    ls -1 "${CURRENT_CWD}/autobuild" | grep -E '.sh' | sed -e 's/\..*$//'
fi

exit 0

