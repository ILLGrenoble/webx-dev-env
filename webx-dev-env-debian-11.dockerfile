FROM debian:11-slim

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y file cmake dpkg-dev pkg-config build-essential libzmq3-dev libpng-dev libwebp-dev libjpeg-dev libxdamage-dev libxrender-dev libxext-dev libxfixes-dev libxcomposite-dev libxkbfile-dev libxtst-dev

RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xrdp dbus dbus-x11
RUN DEBIAN_FRONTEND=noninteractive apt install -y xterm terminator nano less
RUN DEBIAN_FRONTEND=noninteractive apt install -y wget curl unzip git gdb htop valgrind kcachegrind
RUN DEBIAN_FRONTEND=noninteractive apt install -y vlc

# Allow vlc to be run as root
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Install firefox
RUN install -d -m 0755 /etc/apt/keyrings
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y firefox

# Ensure webx-engine is mounted to /app

WORKDIR /app

COPY run_wm.sh /usr/bin
COPY run_dev_env.sh /usr/bin

ENTRYPOINT ["/usr/bin/run_dev_env.sh"]
