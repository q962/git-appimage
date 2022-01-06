## Author: Nelson E Hernandez
FROM centos:centos7
## install build tools
RUN /usr/bin/yum -y update && /usr/bin/yum groupinstall -y "Development Tools" && yum clean all
RUN /usr/bin/yum install -y wget && yum install -y epel-release && yum install -y jq

RUN wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && chmod +x linuxdeploy-x86_64.AppImage \
    && ./linuxdeploy-x86_64.AppImage --appimage-extract \
    && ln -nfs /squashfs-root/usr/bin/linuxdeploy /usr/bin/linuxdeploy

## install git specific packages
RUN yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.9-1.x86_64.rpm
RUN yum install -y git

WORKDIR /git

## complete the appimage build.
COPY ./opt /opt
RUN /opt/build.sh

