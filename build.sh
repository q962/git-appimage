#!/bin/sh

docker build . -t git-appimage
docker create -ti --name gitcontainer git-appimage bash
docker cp gitcontainer:/opt/releases/git.appimage .
docker rm -f  gitcontainer
