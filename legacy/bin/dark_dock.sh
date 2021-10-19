#!/bin/bash

defaults write NSGlobalDomain AppleInterfaceStyle Dark
killall Dock
sleep 4
defaults remove NSGlobalDomain AppleInterfaceStyle
