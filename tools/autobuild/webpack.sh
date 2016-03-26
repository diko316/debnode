#!/bin/sh

"${APP_TOOLS}/installer/npminstall.sh" \
        --apt-permanent \
            libpng-dev \
            libpng12-dev \
        --global \
            webpack \
            webpack-dev-server
