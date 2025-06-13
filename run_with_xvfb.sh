#!/bin/bash

# Start Xvfb with a 24-bit color depth
Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99

# Give Xvfb some time to start
sleep 1

# Set fake audio device to avoid ALSA errors
export SDL_AUDIODRIVER=dummy
export AUDIODEV=/dev/null
export LOVE_AUDIO_DRIVER=dummy
export LOVE_NO_AUDIO=1
export LOVE_AUDIO=0
export LOVE_GRAPHICS_DRIVER=headless

# Set XDG_RUNTIME_DIR if it's not set
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/tmp/runtime-$USER
    mkdir -p $XDG_RUNTIME_DIR
    chmod 700 $XDG_RUNTIME_DIR
fi

# Run Love2D
love .

# Clean up Xvfb when done
kill $!
