#!/bin/sh

NPM_GLOBAL_CMD="npm install -dd -y -g"
NPM_LOCAL_CMD="npm install -dd -y"
APT_INSTALL_CMD="${APP_TOOLS}/installer/install.sh"
APT_UNINSTALL_CMD="${APP_TOOLS}/installer/uninstall.sh"
CLEANUP_CMD="${APP_TOOLS}/installer/cleanup.sh"
PACKAGE_JSON="/tmp/package.json"
INSTALL_APT=
INSTALL_GLOBAL=
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
        APT)
            APT_INSTALL="${APT_INSTALL_CMD} ${ARG}"
            APT_UNINSTALL="${APT_UNINSTALL_CMD} ${ARG}"
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
    echo ${APT_INSTALL}
    ${APT_INSTALL} || exit 1
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
##################
if [ "${INSTALL_LOCAL}" ] && [ -d "${PROJECT_ROOT}" ] && [ -w "${PROJECT_ROOT}" ]; then
    CWD=$(pwd)
    cd "{PROJECT_ROOT}"
    echo "installing: "
    echo ${NPM_LOCAL_CMD}
    ${NPM_LOCAL_CMD} || exit 3
    cd "${CWD}"
fi

##################
# uninstall
##################
if [ "${INSTALL_APT}" ]; then
    echo "uninstalling: "
    echo ${APT_UNINSTALL}
    ${APT_UNINSTALL} || exit 4
fi


##################
# cleanup
##################
echo "cleanup: "
echo ${APT_UNINSTALL}
${CLEANUP_CMD} || exit 5
