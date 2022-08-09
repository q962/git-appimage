#!/bin/bash

cd /app

GIT_VERSION=${1:-${GIT_VERSION:-2.36.1}}

if [ ! -s git.$GIT_VERSION.tar.gz ] ; then
    wget "https://github.com/git/git/archive/v$GIT_VERSION.tar.gz" -O git.$GIT_VERSION.tar.gz

    if [ $? -ne 0 ] ; then
        echo Network Error
        exit 1
    fi

    tar -xf git.$GIT_VERSION.tar.gz
fi

cd git-$GIT_VERSION

# build requires c99
gnu99_number=`awk "/gnu99\" at the end/{print NR+1}" Makefile`
sed "$gnu99_number{s/$/ -std=gnu99/}" -i Makefile

make prefix=/usr all
make prefix=/usr DESTDIR=/AppDir install

find /AppDir -type f -perm /a+x -exec strip {} \;

## Build the appimage
chmod u+x /AppDir/AppRun
OUTPUT="/opt/git.${GIT_VERSION}.appimage" /usr/bin/linuxdeploy --appdir=/AppDir --output=appimage
