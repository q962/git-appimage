#!/bin/sh

alias docker=${DOCKER:-docker}

docker images | grep git-appimage > /dev/null
if [ $? -ne 0 ] ; then
    docker build --tag git-appimage . || exit -1
fi

GIT_VERSION=${1:-2.39.2}

docker run --name gitcontainer -e GIT_VERSION="$GIT_VERSION" git-appimage
docker cp gitcontainer:/opt/git.$GIT_VERSION.appimage .
docker rm -f gitcontainer
