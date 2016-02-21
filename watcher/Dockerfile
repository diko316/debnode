#####################################
# @repository   diko316
#####################################
FROM diko316/debnode:basic

ENV PROJECT_ROOT /opt/app
ENV APP_TOOLS /opt/app-tools
ENV APP_SOURCE /opt/app-source
ENV LOG_FILES /opt/tool-logs

# install watcher
RUN npm install -g watch

# install rsync
RUN apt-get update && apt-get install -y rsync

# add tools
RUN mkdir -p $APP_TOOLS
ADD ./tools $APP_TOOLS
RUN chmod +x -R $APP_TOOLS

# add watcher
RUN ln -s $APP_TOOLS/watch-source.sh /usr/bin/watcher

# log files
RUN mkdir -p $LOG_FILES
RUN mkdir -p $APP_SOURCE
RUN mkdir -p $PROJECT_ROOT

# run watcher daemon in background
CMD watcher




