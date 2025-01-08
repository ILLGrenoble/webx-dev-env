FROM ubuntu:20.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y file cmake dpkg-dev pkg-config build-essential libzmq3-dev libpng-dev libwebp-dev libjpeg-dev libxdamage-dev libxrender-dev libxext-dev libxfixes-dev libxcomposite-dev libxkbfile-dev libxtst-dev

RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xrdp dbus dbus-x11
RUN DEBIAN_FRONTEND=noninteractive apt install -y xterm terminator nano less
RUN DEBIAN_FRONTEND=noninteractive apt install -y curl unzip git

# Ensure webx-engine is mounted to /app

WORKDIR /app

COPY run_wm.sh /usr/bin
COPY run_dev_env.sh /usr/bin

ENTRYPOINT ["/usr/bin/run_dev_env.sh"]
