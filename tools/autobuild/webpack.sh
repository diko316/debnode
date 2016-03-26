#!/bin/sh

"${APP_TOOLS}/installer/autobuild.sh" \
        --apt-permanent \
            libpng-dev \
            libpng12-dev \
        --global \
            webpack \
            webpack-dev-server
