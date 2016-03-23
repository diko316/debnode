#!/bin/sh

apt-get autoremove -y

dpkg --purge $(dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2)

rm -rf /usr/include \
        /usr/share/man \
        /tmp/* \
        /var/cache/apt/* \
        /root/.npm \
        /usr/lib/node_modules/npm/man \
        /usr/lib/node_modules/npm/doc \
        /usr/lib/node_modules/npm/html \
        /var/lib/apt/lists/*

