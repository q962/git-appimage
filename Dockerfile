FROM ubuntu:bionic

## install build tools
RUN apt-get update && apt-get install -y wget jq software-properties-common build-essential make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
RUN wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && chmod +x linuxdeploy-x86_64.AppImage \
    && ./linuxdeploy-x86_64.AppImage --appimage-extract \
    && ln -nfs /squashfs-root/usr/bin/linuxdeploy /usr/bin/linuxdeploy

## install app specific packages
#RUN apt-add-repository "deb http://deb.debian.org/debian buster-backports main"
#RUN apt-get update && apt-get -t buster-backports install -y git

COPY ./opt/* /AppDir/
COPY ./buildgit.sh /app/

ENTRYPOINT [ "/app/buildgit.sh" ]
