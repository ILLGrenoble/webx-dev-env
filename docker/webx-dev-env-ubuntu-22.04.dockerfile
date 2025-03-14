FROM ubuntu:22.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y file cmake dpkg-dev pkg-config build-essential libzmq3-dev libpng-dev libwebp-dev libjpeg-dev libxdamage-dev libxrender-dev libxext-dev libxfixes-dev libxcomposite-dev libxkbfile-dev libxtst-dev

RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xrdp dbus dbus-x11
RUN DEBIAN_FRONTEND=noninteractive apt install -y xterm terminator nano less
RUN DEBIAN_FRONTEND=noninteractive apt install -y curl unzip git gdb htop valgrind kcachegrind
RUN DEBIAN_FRONTEND=noninteractive apt install -y vlc

RUN DEBIAN_FRONTEND=noninteractive apt remove -y xfce4-screensaver

# Allow vlc to be run as root
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Ensure webx-engine is mounted to /app

WORKDIR /app

COPY run_wm.sh /usr/bin
COPY run_dev_env.sh /usr/bin

ENTRYPOINT ["/usr/bin/run_dev_env.sh"]
