#####################################
# @repository   diko316
#####################################
FROM diko316/debnode:basic

ENV PROJECT_ROOT /opt/app
ENV APP_TOOLS /opt/tools
ENV LOG_FILES /opt/tool-logs

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# install inotify-tools
RUN apt-get update && apt-get install -y inotify-tools rsync


# mount source files when running docker run -v source_dir:/opt/app-source
#   to allow automatic sync
ENV APP_SOURCE /opt/app-source


# add tools
RUN mkdir -p $APP_TOOLS
ADD ./tools $APP_TOOLS
RUN chmod +x -R $APP_TOOLS


# log files
RUN mkdir -p $LOG_FILES
RUN mkdir -p $APP_SOURCE
RUN mkdir -p $PROJECT_ROOT

# run watcher daemon in background
CMD /opt/tools/watcher/start.sh




