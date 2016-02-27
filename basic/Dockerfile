#####################################
# @repository   diko316
#####################################
FROM debian:latest

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install curl required for installing Nodejs Argon Repo
RUN apt-get update && apt-get install -y curl

# Install NodeSource Node.js 4.x LTS Argon repo
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs

