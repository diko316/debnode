#!/bin/sh

auto-build \
    --apt-permanent \
        libpng-dev \
        libpng12-dev \
    --global \
        webpack \
        webpack-dev-server
