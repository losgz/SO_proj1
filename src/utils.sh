#!/bin/bash

function mkdirprint(){
    if [[ $CHECKING==0 ]]; then
        mkdir "$1";
    fi
    echo "mkdir $1"
    return 0;
}

function cpprint(){
    if [[ $CHECKING==0 ]]; then
        mkdir "$1";
    fi
    cp -a "$1" "$2";
    echo "cp -a $1 $2"
    return 0;
}