#!/bin/sh

curl --silent -o /tmp/weather.html http://weather.yahoo.com/united-states/vermont/-12759989/
curl --silent -o /tmp/weather.png $(grep "div class="forecast-icon" style="background:url" /tmp/weather.html| awk -F"'" '{ printf $2 }');for NUM in $(grep -n ".*n" /tmp/weather.html|cut -d":" -f1); do TARGET=$((NUM+1)) ; sed -n "$NUM"p /tmp/weather.html|sed 's|||g'|sed 's|||g'| sed 's/^[t]*//'; sed -n "$TARGET"p /tmp/weather.html ; done 