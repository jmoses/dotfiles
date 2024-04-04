#!/bin/bash

pushd config
for d in * ; do
    if [[ ! -d $d ]] ; then
        continue
    fi

    echo "Applying $d"
    stow -t $HOME --dotfiles -v $d
done
