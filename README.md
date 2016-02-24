#debnode

A docker image based on **debian:latest** with **Nodejs** and **NPM** support.

##debnode:basic

This is the basic image imported from **debian:latest** and installed **Nodejs** and **NPM** on it.


##debnode:latest

This is the final image that is aware of source files and that may sync to project directory whenever there are changes.

###Features:


1. **Source awareness**
	* Source codes in your host machine may be mounted inside the container by running:
	
	```
 docker run -v /host_directory:/opt/app-source debnode_image
	 ```

	* Source Watcher will monitor modified files in */opt/app-source* and will be synchronized to */opt/app* using ***rsync*** running in the container.

2. **Project awareness**
	* Project Watcher will monitor modified files in */opt/app* which was synchronized by Source Watcher. If there are modified files found, runner script will be executed.

	* Runner script is run by default at */opt/app/bin/run.sh*. You can also modify script runner file path by setting *APP_RUNNER* environment variable when calling docker run like the code below:

	```
docker run -e 'APP_RUNNER=/opt/app/bin/custom.sh' -v  /host_directory:/opt/app-source debnode_image
	```

	Runner scripts should be an executable file, or else it will not be detected as runner script in Project Watcher.




