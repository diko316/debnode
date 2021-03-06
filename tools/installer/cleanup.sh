#!/bin/sh

apt-get clean || true
apt-get autoclean || true
apt-get autoremove -y || true

dpkg --purge $(dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2) 2>/dev/null || true

rm -rf /usr/include \
        /usr/share/man \
        /tmp/* \
        /var/cache/apt/* \
        /root/.npm \
        /usr/lib/node_modules/npm/man \
        /usr/lib/node_modules/npm/doc \
        /usr/lib/node_modules/npm/html \
        /var/lib/apt/lists/* 2>/dev/null || true

rm -rf $(find "/usr/lib/node_modules" -name test -o -type d | grep '/test$') 2>/dev/null || true

# cleanup $PROJECT_ROOT/node_modules
if [ -d "${PROJECT_ROOT}/node_modules" ]; then
    rm -rf $(find "${PROJECT_ROOT}/node_modules" -name test -o -type d | grep '/test$') 2>/dev/null || true
fi

# cleanup $PROJECT_ROOT/bower_components
if [ -d "${PROJECT_ROOT}/bower_components" ]; then
    rm -rf $(find "${PROJECT_ROOT}/bower_components" -name test -o -type d | grep '/test$') 2>/dev/null || true
fi

if [ -d "/root/.node-gyp" ]; then
    rm -rf "/root/.node-gyp" 2>/dev/null || true
fi

if [ -d "/root/.cache" ]; then
    rm -rf "/root/.cache" 2>/dev/null || true
fi

if [ -d "/root/.config" ]; then
    rm -rf "/root/.config" 2>/dev/null || true
fi

if [ -d "/root/.local" ]; then
    rm -rf "/root/.local" 2>/dev/null || true
fi

if [ -d "/usr/share/doc" ]; then
    rm -rf "/usr/share/doc" 2>/dev/null || true
fi

exit 0