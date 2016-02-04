#!/bin/sh

if xrandr -q | grep -q "DVI-0 connected"
then
    echo "Docked."
fi
