#!/bin/bash 

exec wget --user-agent "Googlebot/2.1 (+http://www.googlebot.com/bot.html)" -c --tries 2 --connect-timeout 10 --read-timeout 10 "$@"
