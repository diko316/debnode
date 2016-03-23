#####################################
# @repository   diko316
#####################################
FROM debian:latest

ENV PROJECT_ROOT=/opt/app APP_TOOLS=/opt/tools LOG_FILES=/opt/tool-logs

ENV APP_SOURCE /opt/app-source
ENV APP_RUNNER $APP_TOOLS/watcher/sample-runner.sh
ENV APP_OBSERVE $PROJECT_ROOT

# add tools
RUN mkdir -p $APP_TOOLS
ADD ./tools $APP_TOOLS
RUN chmod +x -R $APP_TOOLS && \
    mkdir -p $LOG_FILES && \
    mkdir -p $APP_SOURCE && \
    mkdir -p $PROJECT_ROOT && \
    $APP_TOOLS/installer/install.sh \
        build-essential \
        curl \
        git \
        inotify-tools \
        rsync && \
    curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get install -y nodejs git && \
    npm install npm@latest -g -dd && \
    $APP_TOOLS/installer/uninstall.sh \
        build-essential && \
    $APP_TOOLS/installer/cleanup.sh

# Install requisites for installing Nodejs Argon Repo
#RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
#    apt-get update && \
#    apt-get install -y \
#        build-essential \
#        curl \
#        inotify-tools \
#        rsync && \
#    curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
#    apt-get install -y nodejs git && \
#    npm install npm@latest -g -dd && \
#    mkdir -p $APP_TOOLS && \
#    apt-get purge -y build-essential && \
#    apt-get autoremove -y && \
#    dpkg --purge $(dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2) && \
#    rm -rf /usr/include \
#            /usr/share/man \
#            /tmp/* \
#            /var/cache/apt/* \
#            /root/.npm \
#            /usr/lib/node_modules/npm/man \
#            /usr/lib/node_modules/npm/doc \
#            /usr/lib/node_modules/npm/html \
#            /var/lib/apt/lists/*

# run watcher daemon in background
CMD $APP_TOOLS/watcher/start.sh


