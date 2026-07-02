FROM ubuntu:24.04

# Stop interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root

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

# Set up VNC config & startup script
RUN mkdir -p $HOME/.vnc \
    && echo "#!/bin/bash\nstartxfce4 &" > $HOME/.vnc/xstartup \
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
