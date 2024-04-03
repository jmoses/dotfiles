#!/bin/bash

for d in * ; do
    if [[ $d = 'legacy' ]] ; then
        continue
    elif [[ ! -d $d ]] ; then
        continue
    fi

    echo "Applying $d"
    stow -v $d
done
