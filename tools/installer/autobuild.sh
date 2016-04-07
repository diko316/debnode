#!/bin/sh

INSTALLER_PATH=$(dirname $(readlink -m $0))
BUILDER_SCRIPT="${PROJECT_ROOT}/bin/build.sh"
PACKAGE_JSON="/tmp/package.json"
PACKAGE_JSON_DIRECT=
BOWER_JSON="/tmp/bower.json"
BOWER_JSON_DIRECT=

##################
# process args
##################
. "${INSTALLER_PATH}/process-install-args.sh" $*

if [ ! -f "${PACKAGE_JSON}" ] && [ -f "${PROJECT_ROOT}/package.json" ]; then
    PACKAGE_JSON="${PROJECT_ROOT}/package.json"
    PACKAGE_JSON_DIRECT=true
fi

if [ ! -f "${BOWER_JSON}" ] && [ -f "${PROJECT_ROOT}/bower.json" ]; then
    BOWER_JSON="${PROJECT_ROOT}/package.json"
    BOWER_JSON_DIRECT=true
fi


##################
# finalize installation
##################
if [ -f "${BOWER_JSON}" ] || [ -f "${PACKAGE_JSON}" ] || [ "${HAS_NPM_INSTALL}" ]; then
    
    # install/uninstall only if it has not yet been installed
    if ! dpkg -s build-essential > /dev/null 2> /dev/null; then
        APT_INSTALL_CMD="${APT_INSTALL_CMD} build-essential"
        APT_UNINSTALL_CMD="${APT_UNINSTALL_CMD} build-essential"
        INSTALL_APT=true
        UNINSTALL_APT=true
    fi
    
    # install/uninstall only if it has not yet been installed
    if ! dpkg -s git > /dev/null 2> /dev/null; then
        APT_INSTALL_CMD="${APT_INSTALL_CMD} git"
        APT_UNINSTALL_CMD="${APT_UNINSTALL_CMD} git"
        INSTALL_APT=true
        UNINSTALL_APT=true
    fi
fi

if [ -f "${BOWER_JSON}" ]; then
    # install/uninstall only if it has not yet been installed
    if ! npm list -g --depth 0 | grep bower > /dev/null 2> /dev/null; then
        NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} bower"
        NPM_UNINSTALL_CMD="${NPM_UNINSTALL_CMD} bower"
        INSTALL_GLOBAL=true
        UNINSTALL_GLOBAL=true
        HAS_NPM_INSTALL=true
    fi
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
        cd "${CWD}"

        ## relocate if not direct install
        if [ "${PACKAGE_JSON_DIRECT}" != "true" ]; then
            cp -a "${PACKAGE_ROOT}/node_modules" "${PROJECT_ROOT}"
        fi


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
        cd "${CWD}"

        ## relocate if not direct install
        if [ "${BOWER_JSON_DIRECT}" != "true" ]; then
            cp -a "${PACKAGE_ROOT}/bower_components" "${PROJECT_ROOT}"
        fi

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

##################
# custom builder
##################
if [ "${HAS_BUILD_SCRIPTS}" ]; then
    eval ${CUSTOM_BUILD_SCRIPTS_CMD}
fi

##################
# build service
##################
if [ -x "${BUILDER_SCRIPT}" ]; then
    echo "Runing Custom Builder Script ${BUILDER_SCRIPT}..."
    ${BUILDER_SCRIPT} || exit 6
else
    echo "No Defined Custom Builder Script (${BUILDER_SCRIPT}). Skipping custom build."
fi


if [ "${UNINSTALL_GLOBAL}" ]; then
    echo "uninstalling volatile packages: "
    echo ${NPM_UNINSTALL_CMD}
    ${NPM_UNINSTALL_CMD} || exit 7
fi

##################
# uninstall
##################
if [ "${UNINSTALL_APT}" ]; then
    echo "uninstalling: "
    echo ${APT_UNINSTALL_CMD}
    ${APT_UNINSTALL_CMD} || exit 8

##################
# cleanup
##################
elif [ "${HAS_NPM_INSTALL}" ] || [ "${INSTALL_APT}" ]; then
    echo "cleanup: "
    echo ${CLEANUP_CMD}
    ${CLEANUP_CMD} || exit 9
fi


exit 0
