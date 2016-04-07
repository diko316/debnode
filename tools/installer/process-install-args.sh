#!/bin/sh

NPM_GLOBAL_CMD="npm install -dd -y -g"
NPM_LOCAL_CMD="npm install -dd -y"
NPM_UNINSTALL_CMD="npm uninstall -dd -y -g"
APT_INSTALL_CMD="${APP_TOOLS}/installer/install.sh"
APT_UNINSTALL_CMD="${APP_TOOLS}/installer/uninstall.sh"
CLEANUP_CMD="${APP_TOOLS}/installer/cleanup.sh"
CUSTOM_BUILD_SCRIPTS_CMD=
INSTALL_APT=
UNINSTALL_APT=
INSTALL_GLOBAL=
UNINSTALL_GLOBAL=
INSTALL_LOCAL=
HAS_NPM_INSTALL=
HAS_BUILD_SCRIPTS=
HAS_APT_INSTALL=
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
    elif [ "${ARG}" = "--builder" ]; then
        MODE=CUSTOM_BUILDER
    else
        case "${MODE}" in
        GLOBAL)
            NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} ${ARG}"
            INSTALL_GLOBAL=true
            HAS_NPM_INSTALL=true
            ;;
        LOCAL)
            NPM_LOCAL_CMD="${NPM_LOCAL_CMD} ${ARG}"
            INSTALL_LOCAL=true
            HAS_NPM_INSTALL=true
            ;;
        VOLATILE)
            NPM_GLOBAL_CMD="${NPM_GLOBAL_CMD} ${ARG}"
            NPM_UNINSTALL_CMD="${NPM_UNINSTALL_CMD} ${ARG}"
            INSTALL_GLOBAL=true
            UNINSTALL_GLOBAL=true
            HAS_NPM_INSTALL=true
            ;;
        APT)
            APT_INSTALL_CMD="${APT_INSTALL_CMD} ${ARG}"
            APT_UNINSTALL_CMD="${APT_UNINSTALL_CMD} ${ARG}"
            INSTALL_APT=true
            UNINSTALL_APT=true
            HAS_APT_INSTALL=true
            ;;
        APT_PERMANENT)
            APT_INSTALL_CMD="${APT_INSTALL_CMD} ${ARG}"
            INSTALL_APT=true
            HAS_APT_INSTALL=true
            ;;
        CUSTOM_BUILDER)
            if [ "${CUSTOM_BUILD_SCRIPTS_CMD}" ]; then
                CUSTOM_BUILD_SCRIPTS_CMD="${CUSTOM_BUILD_SCRIPTS_CMD}"'\n'"${ARG}"
            else
                CUSTOM_BUILD_SCRIPTS_CMD="${ARG}"
            fi
            HAS_BUILD_SCRIPTS=true
            ;;
        esac
    fi
done



export NPM_GLOBAL_CMD
export NPM_LOCAL_CMD
export NPM_UNINSTALL_CMD
export APT_INSTALL_CMD
export APT_UNINSTALL_CMD
export CUSTOM_BUILD_SCRIPTS_CMD
export CLEANUP_CMD
export INSTALL_APT
export UNINSTALL_APT
export INSTALL_GLOBAL
export UNINSTALL_GLOBAL
export INSTALL_LOCAL
export HAS_NPM_INSTALL
export HAS_APT_INSTALL
export HAS_BUILD_SCRIPTS
export MODE

