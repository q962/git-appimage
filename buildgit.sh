#!/bin/bash

cd /app

if [ -z "GIT_VERSION" ] ; then
    echo "Requires github git tag number"
    exit -1;
fi

if [ ! -s git.$GIT_VERSION.tar.gz ] ; then
    wget "https://github.com/git/git/archive/v$GIT_VERSION.tar.gz" -O git.$GIT_VERSION.tar.gz

    if [ $? -ne 0 ] ; then
        echo Network Error
        exit 1
    fi

    tar -xf git.$GIT_VERSION.tar.gz
fi

cd git-$GIT_VERSION

make CFLAGS="-O2 -Wall -std=gnu99" prefix=/usr DESTDIR=/AppDir install || exit -1

## Build the appimage
chmod u+x /AppDir/AppRun

OUTPUT="/opt/git.${GIT_VERSION}.appimage" \
    /usr/bin/linuxdeploy \
    --appdir=/AppDir --output=appimage \
    --deploy-deps-only=/AppDir/usr/libexec/git-core/
