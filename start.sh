#!/bin/bash

# Force English language for the script environment
export USER=root
export HOME=/root
export LANG=en_US.UTF-8

# Clean up any old VNC lock files
rm -rf /tmp/.X* /tmp/.X11-unix

# Start VNC server (Display :1)
vncserver :1 -localhost yes -geometry 1280x720 -depth 24

# Listen on Railway's dynamic PORT (fallback to 8080 if not set)
LISTEN_PORT=${PORT:-8080}

echo "Starting noVNC on port $LISTEN_PORT..."

# Start websockify to bridge noVNC web interface to VNC
# IMPORTANT: Added 0.0.0.0 to properly expose the port on Railway
exec websockify --web /usr/share/novnc 0.0.0.0:$LISTEN_PORT localhost:5901
