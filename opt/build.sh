#!/bin/bash
mkdir /opt/releases

export OUTPUT="/opt/releases/git.appimage"

/usr/bin/linuxdeploy --appdir=AppDir \
  -i /opt/logo-square.png \
  -d /opt/icon.desktop \
  -e /usr/local/bin/git \
  --custom-apprun=/opt/AppRun \
  --output=appimage
