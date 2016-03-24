#!/bin/sh

NPM_GLOBAL_CMD="npm install -g"
NPM_LOCAL_CMD="npm install"
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
    
    case "${ARG}" in
    "--global")
        MODE=GLOBAL
        continue
        ;;
    "--local")
        MODE=LOCAL
        continue
        ;;
    "--apt")
        MODE=APT
        continue
        ;;
    esac
    
    case "${MODE}" in
    GLOBAL)
        NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} '${ARG}'"
        INSTALL_GLOBAL=true
        ;;
    LOCAL)
        NPM_LOCAL_CMD="${NPM_LOCAL_CMD} '${ARG}'"
        INSTALL_LOCAL=true
        ;;
    APT)
        APT_INSTALL="${APT_INSTALL_CMD} '${ARG}'"
        APT_UNINSTALL="${APT_UNINSTALL_CMD} '${ARG}'"
        INSTALL_APT=true
        ;;
    esac
done


##################
# install apt
##################
if [ "${INSTALL_APT}" ]; then
    ${APT_INSTALL}
fi

##################
# install global
##################
if [ "${INSTALL_GLOBAL}" ]; then
    ${NPM_GLOBAL_CMD}
fi

##################
# install local
##################
if [ "${INSTALL_LOCAL}" ] && [ -d "${PROJECT_ROOT}" ] && [ -w "${PROJECT_ROOT}" ]; then
    CWD=$(pwd)
    cd "{PROJECT_ROOT}"
    ${NPM_LOCAL_CMD}
    cd "${CWD}"
fi

##################
# uninstall
##################
if [ "${INSTALL_APT}" ]; then
    ${APT_UNINSTALL}
fi


##################
# cleanup
##################
${CLEANUP_CMD}
