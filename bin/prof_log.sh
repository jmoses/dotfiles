#!/bin/sh

rake clear_logs
time curl -o /tmp/trash.txt -s $1
echo "Selects: "
grep SELECT log/development.log | wc -l
