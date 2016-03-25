#!/bin/sh

NPM_GLOBAL_CMD="npm install -dd -y -g"
NPM_LOCAL_CMD="npm install -dd -y"
NPM_UNINSTALL_CMD="npm uninstall -dd -y -g"
APT_INSTALL_CMD="${APP_TOOLS}/installer/install.sh"
APT_UNINSTALL_CMD="${APP_TOOLS}/installer/uninstall.sh"
CLEANUP_CMD="${APP_TOOLS}/installer/cleanup.sh"
PACKAGE_JSON="/tmp/package.json"
BOWER_JSON="/tmp/bower.json"
INSTALL_APT=
UNINSTALL_APT=
INSTALL_GLOBAL=
UNINSTALL_GLOBAL=
INSTALL_LOCAL=
MODE=LOCAL

while [ $# -gt 0 ]; do
    ARG=$1
    shift 1
    
    if [ "${ARG}" = "--global" ]; then
        MODE=GLOBAL
    elif [ "${ARG}" = "--local" ]; then
        MODE=LOCAL
    elif [ "${ARG}" = "--apt" ]; then
        MODE=APT
    elif [ "${ARG}" = "--apt-permanent" ]; then
        MODE=APT_PERMANENT
    elif [ "${ARG}" = "--volatile" ]; then
        MODE=VOLATILE
    else
        case "${MODE}" in
        GLOBAL)
            NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} ${ARG}"
            INSTALL_GLOBAL=true
            ;;
        LOCAL)
            NPM_LOCAL_CMD="${NPM_LOCAL_CMD} ${ARG}"
            INSTALL_LOCAL=true
            ;;
        VOLATILE)
            NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} ${ARG}"
            NPM_UNINSTALL_CMD="${NPM_UNINSTALL_CMD} ${ARG}"
            INSTALL_GLOBAL=true
            UNINSTALL_GLOBAL=true
            ;;
        APT)
            APT_INSTALL_CMD="${APT_INSTALL_CMD} ${ARG}"
            APT_UNINSTALL_CMD="${APT_UNINSTALL_CMD} ${ARG}"
            INSTALL_APT=true
            UNINSTALL_APT=true
            ;;
        APT_PERMANENT)
            APT_INSTALL_CMD="${APT_INSTALL_CMD} ${ARG}"
            INSTALL_APT=true
            ;;
        esac
    fi
done


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
        echo "installing package.json files: "
        cd "${PACKAGE_ROOT}"
        npm install bower -g -dd || exit 4
        bower install -V --config.interactive=false --allow-root || exit 5
        npm uninstall bower -g -dd || exit 6
        cp -a "${PACKAGE_ROOT}/bower_components" "${PROJECT_ROOT}"
        cd "${CWD}"
    fi
    
    ##################
    # install local
    ##################
    if [ "${INSTALL_LOCAL}" ]; then
        cd "{PROJECT_ROOT}"
        echo "installing: "
        echo ${NPM_LOCAL_CMD}
        ${NPM_LOCAL_CMD} || exit 7
        cd "${CWD}"
    fi
fi


if [ "${UNINSTALL_GLOBAL}" ]; then
    echo "uninstalling volatile packages: "
    echo ${NPM_UNINSTALL_CMD}
    ${NPM_UNINSTALL_CMD} || exit 8
fi

##################
# uninstall
##################
if [ "${UNINSTALL_APT}" ]; then
    echo "uninstalling: "
    echo ${APT_UNINSTALL_CMD}
    ${APT_UNINSTALL_CMD} || exit 9
fi


##################
# cleanup
##################
echo "cleanup: "
echo ${CLEANUP_CMD}
${CLEANUP_CMD} || exit 10


exit 0