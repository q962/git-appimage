#!/bin/bash
mkdir /opt/releases

cd /git

export OUTPUT="/opt/releases/git.appimage"

/usr/bin/linuxdeploy --appdir=AppDir \
  -i /opt/logo-square.png \
  -d /opt/icon.desktop \
  -e /usr/bin/git \
  --custom-apprun=/opt/AppRun \
  --output=appimage
