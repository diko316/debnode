#####################################
# @repository   diko316
#####################################
FROM debian:latest


RUN apt-get update && apt-get install -y nodejs npm

# fix nodejs/node command
RUN ln -s $(which nodejs) /usr/bin/node 