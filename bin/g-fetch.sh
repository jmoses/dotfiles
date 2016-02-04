#!/bin/bash 

exec wget --user-agent "Googlebot/2.1 (+http://www.googlebot.com/bot.html)" -c --tries 2 "$@"
