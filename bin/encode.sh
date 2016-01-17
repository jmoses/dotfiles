#!/bin/bash

base=$(basename "$1" .avi)

HandBrakeCLI --preset "High Profile" -i "$1" -o "/Volumes/Sneezy/movies/$base.m4v"

curl -d "email=jon@burningbush.us" \
  -d "&notification[from_screen_name]=HandBrake" \
  -d "&notification[message]=$base complete." \
  http://boxcar.io/devices/providers/kEciXyurv5AWEPWy1IJy/notifications
