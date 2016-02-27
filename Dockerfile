#####################################
# @repository   diko316
#####################################
FROM debian:latest

ENV PROJECT_ROOT /opt/app
ENV APP_TOOLS /opt/tools
ENV LOG_FILES /opt/tool-logs

ENV APP_SOURCE /opt/app-source
ENV APP_RUNNER /opt/app/

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install requisites for installing Nodejs Argon Repo
RUN apt-get update && apt-get install -y \
                                        build-essential \
                                        curl \
                                        inotify-tools \
                                        rsync

# Install NodeSource Node.js 4.x LTS Argon repo
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs

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


