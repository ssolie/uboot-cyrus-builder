#
# Dockerfile to build Das U-Boot for the Cyrus motherboards
#
# The source code is assumed to be in
#  /opt/u-boot
#
# which is also the work directory.
#

FROM debian:jessie

LABEL maintainer="Steven Solie <steven@solie.ca>"

#
# This is where the source code is located and the build takes place.
#
WORKDIR /opt/u-boot

#
# Perform all the steps in a single RUN to avoid creating file system layers.
#
RUN apt-get update && apt-get upgrade --yes && \
  apt-get install -y \
    make \
    gcc-4.9 \
    curl \
    xz-utils \
  && \
  ln -s /usr/bin/gcc-4.9 /usr/bin/gcc \
  && \
  curl -fSl "http://newos.org/toolchains/powerpc-elf-4.9.1-Linux-x86_64.tar.xz" -o /tmp/powerpc-elf-4.9.1-Linux-x86_64.tar.xz && \
  cd /tmp && \
  xz -d powerpc-elf-4.9.1-Linux-x86_64.tar.xz && \
  tar xf powerpc-elf-4.9.1-Linux-x86_64.tar && \
  mv powerpc-elf-4.9.1-Linux-x86_64 /opt/powerpc-elf-4.9.1 && \
  rm powerpc-elf-4.9.1-Linux-x86_64.tar \
  && \
  apt-get --assume-yes purge \
    curl \
    xz-utils \
  && \
  apt-get --assume-yes autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

#
# Add the cross-compiler to the PATH
#
ENV PATH=/opt/powerpc-elf-4.9.1/bin:$PATH

