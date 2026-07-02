FROM ubuntu:24.04

# Stop interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root

# Install locales and set default language to English US
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Force Environment variables to English US
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Update and install lightweight GUI, VNC, noVNC and basic tools
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    curl \
    wget \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC config & startup script (Force English in VNC session too)
RUN mkdir -p $HOME/.vnc \
    && echo "#!/bin/bash\nexport LANG=en_US.UTF-8\nstartxfce4 &" > $HOME/.vnc/xstartup \
    && chmod +x $HOME/.vnc/xstartup

# Set VNC password (Password: railway)
RUN echo "railway" | vncpasswd -f > $HOME/.vnc/passwd \
    && chmod 600 $HOME/.vnc/passwd

# Symlink noVNC index page so it loads by default
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Copy the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run the startup script
CMD ["/start.sh"]
