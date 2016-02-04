#!/bin/sh

webs="10.50.10.1 10.50.10.2 10.50.10.3"
webs_b="10.60.10.4 10.60.10.5 10.60.10.6 10.60.10.7"
dbs="10.50.20.1 10.50.20.2 10.50.20.3"
dbs_b="10.60.20.4"
files_b="10.60.30.2 10.60.30.3"
monitors_b="10.60.40.2"

multi_hosting_base="multixterm -xc 'slogin reso@%n'"
case "$1" in
  webs)
   cmd="${multi_hosting_base} ${webs}"
   $cmd
  ;;

  webs2)
   exec $multi_hosting_base $webs_b
  ;;

  *)
    echo "Nothing found."
  ;;
esac

#alias multi_hosting_base_j="multixterm -xc 'slogin %n'"
#alias multi_webs="multi_hosting_base ${webs}"
#alias multi_dbs="multi_hosting_base ${dbs}"
#alias multi_hosting_new_all="multi_hosting_base ${webs_b} ${dbs_b} ${files_b} ${monitors_b}"
