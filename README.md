# WebX Dev Environment

This project is used to build Docker images that run an X11 environment with the Xfce4 desktop manager. The images also include the necessary dependencies to build the [WebX Engine](https://github.com/ILLGrenoble/webx-engine) under the different linux flavours.

This allows a WebX Developer to build and run the WebX Engine within multiple environments (developer's host can be Linux, Mac or Windows) and test it locally using the [WebX Relay](https://github.com/ILLGrenoble/webx-relay) and [WebX client](https://github.com/ILLGrenoble/webx-client) (for example using the [WebX Demo Server](https://github.com/ILLGrenoble/webx-demo-server) and [WebX Demo Client](https://github.com/ILLGrenoble/webx-demo-client) projects).

## Building a dev environment

To build a dev environment run the following command (for example to build the ubuntu-22.04 environment):

```
docker build -t webx-dev-env-ubuntu:22.04 -f webx-dev-env-ubuntu-22.04.dockerfile .
```

This generates a Docker image called `webx-dev-env-ubuntu:22.04`.

## Running a dev environment

The dev environment runs an Xfce4 desktop manager. For this to be useful for the WebX Engine development you need to:
 - mount the source to WebX Engine inside the container
 - expose the ports 5555-5558 to the host

The simplest way to do this is to navigate in a terminal to your WebX Engine project and run the following command:

```
docker run --rm -v `pwd`:/app -p 5555-5558:5555-5558 --name webx-dev-env webx-dev-env-ubuntu:22.04
```

By default this runs X11 on DISPLAY :20 with a resolution of 1920x1080. You can modify these values by adding arguments to the above command. For example

```
docker run --rm -v `pwd`:/app -p 5555-5558:5555-5558 --name webx-dev-env webx-dev-env-ubuntu:22.04 -d :10 -w 2560 -h 1440
```

will run the display manager on DISPLAY :10 with a resolution of 2560x1440.

## Stopping the dev environment

To stop the dev environment container use `ctrl-c` if the container is running in the foreground. You can also stop the container by running

```
docker stop webx-dev-env
```

## Building and running the WebX Engine within the dev environment

Now we have the X11 environment running with Xfce4 we can build the WebX Engine and run it.

Previously we mounted the WebX Engine source to `/app` within the container. By executing a bash shell within the container we can build and run the engine:

```
docker exec -it webx-dev-env bash
```

you should be in the `/app` directory and typing `ls` should show you the WebX Engine source.

To build the WebX Engine type:

```
cmake .
cmake --build . -j 4 --target webx-engine
```

You can then run the WebX Engine with the command:

```
DISPLAY=:20 ./bin/webx-engine -s
```

This runs the WebX Engine in <em>standalone</em> mode (meaning that it can be connected to directly without the need of the WebX Router and WebX Session Manager) on DISPLAY :20 (if you chose to modify the DISPLAY you'll have to change the command accordingly).

You should see some output similar to the following:
```
[2025-01-06 10:30:54.427] [info] Starting WebX in stand-alone mode
[2025-01-06 10:30:54.427] [info] Starting WebX server
[2025-01-06 10:30:54.451] [info] Got keyboard layout 'us' from X11. Searching for mapping...
[2025-01-06 10:30:54.451] [info] ... loaded keyboard mapping 'en_us_qwerty'
```

> Note that if you change environments (eg from Ubuntu 22.04 to Debian 11) it is likely that you'll have to recompile the WebX Engine. To do this you can simply run the command `make clean` and then re-run the `cmake` commands above.

## Running the WebX Demo

The simplest way to test the WebX Engine is to run the WebX Demo using the [WebX Demo Deploy](https://github.com/ILLGrenoble/webx-demo-deploy) project. 

This project runs the WebX Demo web application in a docker environment. The Demo application is composed of the Java backend [WebX Demo Server](https://github.com/ILLGrenoble/webx-demo-server) and the frontend [WebX Demo Client](https://github.com/ILLGrenoble/webx-demo-client), demoing the full transport of data between the WebX Engine to the user's browser using the [WebX Relay](https://github.com/ILLGrenoble/webx-relay) to bridge the WebX socket and the [WebX Client](https://github.com/ILLGrenoble/webx-client) websocket.

Clone the WebX Demo Deploy project:

```
git clone https://github.com/ILLGrenoble/webx-demo-deploy
cd webx-demo-deploy
```

Run the deployment script to attach to the <em>standalone</em> WebX Engine running on the same host:

```
./deploy.sh -sh host.docker.internal
```

This will start the demo web application and the demo server will connect to the WebX Engine running on the host machine.

In a browser, open a new tab at https://localhost

Clicking on the `Connect` button will connect you to your WebX Engine running in you WebX development environment.
