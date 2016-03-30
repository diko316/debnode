#!/bin/sh

INSTALLER_PATH=$(dirname $(readlink -m $0))
PACKAGE_JSON="/tmp/package.json"
BOWER_JSON="/tmp/bower.json"

##################
# process args
##################
. "${INSTALLER_PATH}/process-install-args.sh" $*


##################
# finalize installation
##################
if [ -f "${BOWER_JSON}" ] || [ -f "${PACKAGE_JSON}" ] || [ "${HAS_NPM_INSTALL}" ]; then
    APT_INSTALL_CMD="${APT_INSTALL_CMD} build-essential git"
    APT_UNINSTALL_CMD="${APT_UNINSTALL_CMD} build-essential git"
    INSTALL_APT=true
    UNINSTALL_APT=true
fi

if [ -f "${BOWER_JSON}" ]; then
    NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} bower"
    NPM_UNINSTALL_CMD="${NPM_UNINSTALL_CMD} bower"
    INSTALL_GLOBAL=true
    UNINSTALL_GLOBAL=true
    HAS_NPM_INSTALL=true
fi


##################
# install apt
##################
if [ "${INSTALL_APT}" ]; then
    echo "installing: "
    echo ${APT_INSTALL_CMD}
    ${APT_INSTALL_CMD} || exit 1
fi

##################
# install global
##################
if [ "${INSTALL_GLOBAL}" ]; then
    echo "installing: "
    echo ${NPM_GLOBAL_CMD}
    ${NPM_GLOBAL_CMD} || exit 2
fi

##################
# install local
#   packages
##################
if [ -d "${PROJECT_ROOT}" ]; then
    CWD=$(pwd)
    PACKAGE_ROOT=$(dirname "${PACKAGE_JSON}")
    ##################
    # install packages
    #   from
    #   package.json
    ##################
    if [ -f "${PACKAGE_JSON}" ] && [ -r "${PACKAGE_JSON}" ]; then
        echo "installing package.json files: "
        cd "${PACKAGE_ROOT}"
        npm install -dd -y || exit 3
        cp -a "${PACKAGE_ROOT}/node_modules" "${PROJECT_ROOT}"
        cd "${CWD}"
    fi

    ##################
    # install packages
    #   from
    #   bower.json
    ##################
    if [ -f "${BOWER_JSON}" ] && [ -r "${BOWER_JSON}" ]; then
        echo "installing bower.json files: "
        cd "${PACKAGE_ROOT}"
        bower install -V --config.interactive=false --allow-root || exit 4
        cp -a "${PACKAGE_ROOT}/bower_components" "${PROJECT_ROOT}"
        cd "${CWD}"
    fi

    ##################
    # install local
    ##################
    if [ "${INSTALL_LOCAL}" ]; then
        cd "${PROJECT_ROOT}"
        echo "installing: "
        echo ${NPM_LOCAL_CMD}
        ${NPM_LOCAL_CMD} || exit 5
        cd "${CWD}"
    fi
fi


if [ "${UNINSTALL_GLOBAL}" ]; then
    echo "uninstalling volatile packages: "
    echo ${NPM_UNINSTALL_CMD}
    ${NPM_UNINSTALL_CMD} || exit 6
fi

##################
# uninstall
##################
if [ "${UNINSTALL_APT}" ]; then
    echo "uninstalling: "
    echo ${APT_UNINSTALL_CMD}
    ${APT_UNINSTALL_CMD} || exit 7
fi


##################
# cleanup
##################
if [ "${HAS_NPM_INSTALL}" ] || [ "${INSTALL_APT}" ]; then
    echo "cleanup: "
    echo ${CLEANUP_CMD}
    ${CLEANUP_CMD} || exit 8
fi


exit 0
