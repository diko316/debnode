#####################################
# @repository   diko316
#####################################
FROM debian:latest

ENV PROJECT_ROOT=/opt/app APP_TOOLS=/opt/tools LOG_FILES=/opt/tool-logs APP_SOURCE=/opt/app-source APP_RUNNER=$APP_TOOLS/watcher/sample-runner.sh APP_OBSERVE=$PROJECT_ROOT

# add tools
RUN mkdir -p $APP_TOOLS
ADD ./tools $APP_TOOLS

# Install requisites for installing Nodejs
RUN mkdir -p $LOG_FILES && \
    mkdir -p $APP_SOURCE && \
    mkdir -p $PROJECT_ROOT && \
    mkdir -p /tmp && \
    "$APP_TOOLS/installer/install.sh" \
        build-essential \
        curl \
        git \
        inotify-tools \
        rsync && \
    curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get install -y nodejs && \
    npm install npm@latest -g -dd && \
    "$APP_TOOLS/installer/uninstall.sh" \
        build-essential && \
    "$APP_TOOLS/installer/cleanup.sh"

# test webpack
#RUN "$APP_TOOLS/autobuild.sh" webpack

# run watcher daemon in background
CMD $APP_TOOLS/watcher/start.sh


