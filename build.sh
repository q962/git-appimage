#!/bin/sh

docker build --build-arg GIT_VERSION="$1" --tag git-appimage .
docker create -ti --name gitcontainer git-appimage bash
docker cp gitcontainer:/opt/releases/git.appimage .
docker rm -f  gitcontainer
