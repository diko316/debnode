#!/bin/sh

CURRENT_CWD=$(dirname $(readlink -m $0))
BUILDER="${CURRENT_CWD}/autobuild/${1}.sh"
PACKAGE_JSON="${PROJECT_ROOT}/package.json"
BOWER_JSON="${PROJECT_ROOT}/bower.json"

# Call autobuild with preset
if [ -f "${BUILDER}" ] && [ -x "${BUILDER}" ]; then
    ${BUILDER} || exit 1

# Call autobuild without preset
elif [ -f "${PACKAGE_JSON}" ] || [ -f "${BUILD_JSON}" ]; then
    "$APP_TOOLS/installer/autobuild.sh" || exit 2
    
# Show Warning
else
    echo "No builder used, or builder not found: $1"
    echo "* Please use one of the builders below:"
    ls -1 "${CURRENT_CWD}/autobuild" | grep -E '.sh' | sed -e 's/\..*$//'
fi

exit 0
