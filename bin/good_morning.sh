#!/bin/bash

#sudo uptime
#sudo /usr/local/mysql/bin/mysqld_safe --user=mysql &
#ssh-add
#encfs ~/crypt/private ~/mnt/private
#sshfs jmoses@wd:/home/jmoses /home/jmoses/mnt/wd-home/
###cd ~/dev/reso-shop && mongrel_rails start -d
#cd ~/dev/reso-shop && rake clear_logs
#tilda &

for f in /home/jmoses/bin/gm-parts/*; do
    `$f`
done
