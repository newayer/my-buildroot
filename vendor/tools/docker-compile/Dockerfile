FROM ubuntu:16.04

MAINTAINER newayer <cn_gwq@sina.com>

ENV LANG en_US.utf8
ENV HOST_USER newayer
ENV HOST_GID 1001
ENV HOST_UID 1001
ENV PASSWORD ubuntu

ARG DEBIAN_FRONTEND=noninteractive

COPY files/build.sh /

RUN /build.sh

USER ${HOST_USER}
WORKDIR /home/${HOST_USER}

