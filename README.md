#debnode

A docker image based on **debian:latest** with **Nodejs** and **NPM** support.

##debnode:latest

This image is based on **debian:latest** with pre-installed **Nodejs** and **NPM**, Source awareness tools, and Autobuild tools to help further installations of apt-get and npm packages .

###Features:


1. **Source awareness**
	* Source codes in your host machine may be mounted inside the container by running:
	
	```
 docker run -v /host_directory:/opt/app-source debnode_image
	 ```

	* Source Watcher will monitor modified files in */opt/app-source* and will be synchronized to */opt/app* using ***rsync*** running in the container.
>	**Warning!** This is not tested on vboxsf and ntfs file systems on mounted volumes which probably do not work due to limitations of inotifywait. This will work best on ext* file systems as tested while developing this image.

2. **Project awareness**
	* Project Watcher will monitor modified files in */opt/app* which was synchronized by Source Watcher. If there are modified files found, runner script will be executed.

	* Runner script is run by default at */opt/app/sample-runner.sh*. You can also modify script runner file path by setting *APP_RUNNER* environment variable when calling docker run like the code below:

	```
docker run -e 'APP_RUNNER=/opt/app/bin/custom_runner.sh' -v  /host_directory:/opt/app-source debnode_image
	```
>	**Info!** Runner scripts should be an executable file, or else it will not be detected as runner script in Project Watcher.

3. **Autobuild**

	* Autobuild tools are preinstalled in */opt/tools/installer*. Sample autobuild scripts are found in */opt/tools/autobuild* directory.

	* Autobuild tools is useful when you are extending this image and installing additional apt-get packages, npm packages, and bower packages.
	
	* Installation of apt-get packages may come in two forms.
		1. *--apt* -- These packages will be installed first and will be uninstalled before Autobuild exits.
		2. *--apt-permanent* -- These packages will be installed first together with *--apt* but will not be uninstalled.
> 	**Info!** If there are npm installations required for Autobuild, then "build-essential" package will be preinstalled.
>	So, there is no need to declare this installation as Autobuild arguments.
	* Installation of global npm packages may come in three forms.
		1. *--global* -- These packages will be installed after all installations of apt-get packages. 
		2. *--volatile* -- These packages will be installed together with *--global* but will be uninstalled before all apt-get packages will be uninstalled.
		3. *--local* -- These packages will be installed in your ***"$PROJECT_ROOT"*** *(/opt/app)*. This package installation is not recommended since this will not be versioned properly using package.json.
> 	**Info!** Instead of using ***--local*** installation of npm packages.
>	 You can use **package.json** and **bower.json** autoinstall in order to use the convenience features of npm and bower package managers.
	* Autobuild tools can also be used to autoinstall package.json and bower.json by adding one or all of these files to */tmp* directory and calling Autobuild script ***"${APP_TOOLS}/installer/autobuild.sh"***. 
		1. **package.json** dependencies will be installed first after installing npm global packages. And ***node_modules*** directory will be placed on ***$PROJECT_ROOT*** directory.
		2. **bower.json** dependencies will be installed afterwards. Then, ***bower_components*** directory will be placed on ***$PROJECT_ROOT***.

### Autobuild Examples:

#### Gulp Build Dockerfile
This example is taken from [diko316/debnode-gulp](https://github.com/diko316/debnode-gulp)  which contains skeleton gulp built app not build with the image but just there for reference purposes.
```
FROM diko316/debnode:latest

# change the path to /opt/app when using this image
ENV APP_RUNNER=$APP_TOOLS/gulp/start.sh
ENV APP_OBSERVE=$PROJECT_ROOT/gulpfile.js

# add gulp tools
ADD ./tools $APP_TOOLS

# other gulp dependencies package.json and bower.json
ADD package.json /tmp/package.json
ADD bower.json /tmp/bower.json

# autobuild gulp stack
RUN "$APP_TOOLS/autobuild.sh" gulp

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh

```


#### Gulp Build Dockerfile without using  autobuild preset
```
FROM diko316/debnode:latest

# change the path to /opt/app when using this image
ENV APP_RUNNER=$APP_TOOLS/gulp/start.sh
ENV APP_OBSERVE=$PROJECT_ROOT/gulpfile.js

# add gulp tools
ADD ./tools $APP_TOOLS

# other gulp dependencies package.json and bower.json
ADD package.json /tmp/package.json
ADD bower.json /tmp/bower.json

# autobuild gulp stack
RUN "${APP_TOOLS}/installer/autobuild.sh" \
	--apt-permanent \
            libpng-dev \
            libpng12-dev \
	--global \
            gulp \
            browser-sync

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh
```