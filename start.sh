#!/bin/bash
export USER=root
export HOME=/root

# Clean up any old VNC lock files
rm -rf /tmp/.X* /tmp/.X11-unix

# Start VNC server (Display :1)
vncserver :1 -localhost yes -geometry 1280x720 -depth 24

# Listen on Railway's dynamic PORT (fallback to 8080 if not set)
LISTEN_PORT=${PORT:-8080}

echo "Starting noVNC on port $LISTEN_PORT..."

# Start websockify to bridge noVNC web interface to VNC
exec websockify --web /usr/share/novnc $LISTEN_PORT localhost:5901
