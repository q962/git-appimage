ARG GIT_VERSION=1.9.1
FROM ubuntu:trusty

ARG GIT_VERSION
RUN echo "$GIT_VERSION"
## install build tools
RUN apt-get update && apt-get install -y wget jq software-properties-common build-essential
RUN wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && chmod +x linuxdeploy-x86_64.AppImage \
    && ./linuxdeploy-x86_64.AppImage --appimage-extract \
    && ln -nfs /squashfs-root/usr/bin/linuxdeploy /usr/bin/linuxdeploy

## install app specific packages
#RUN apt-add-repository "deb http://deb.debian.org/debian buster-backports main"
#RUN apt-get update && apt-get -t buster-backports install -y git
WORKDIR /app
RUN apt-get install -y make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
RUN wget "https://github.com/git/git/archive/v$GIT_VERSION.tar.gz" -O git.tar.gz
RUN tar -xf git.tar.gz
RUN cd git-* && gnu99_number=`awk "/gnu99\" at the end/{print NR+1}" Makefile` && sed "$gnu99_number{s/$/ -std=gnu99/}" -i Makefile
RUN cd git-* && make prefix=/usr/local all
RUN cd git-* && make prefix=/usr/local DESTDIR=/AppDir install
RUN cd git-* && find /AppDir/usr/local/bin -exec strip {} \;
RUN cd git-* && find /AppDir/usr/local/libexec/git-core -exec strip {} \;

## Build the appimage
COPY ./opt/* /AppDir/
RUN chmod u+x /AppDir/AppRun
RUN OUTPUT="/opt/git.appimage" /usr/bin/linuxdeploy --appdir=/AppDir --output=appimage
