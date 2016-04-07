#!/bin/sh


apt-get purge -y --auto-remove $* || true

${APP_TOOLS}/installer/cleanup.sh || true

