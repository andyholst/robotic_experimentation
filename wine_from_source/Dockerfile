FROM debian:buster-slim as amd64

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget gnupg2 software-properties-common libvulkan* \
fakeroot dh-make git libasound2-dev libdbus-1-dev libfontconfig-dev libfreetype6-dev libgnutls28-dev libpng-dev \
libtiff-dev libgl-dev libunwind-dev libxml2-dev libxslt1-dev libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev libmpg123-dev libosmesa6-dev libsdl2-dev libudev-dev libvulkan-dev \
ocl-icd-opencl-dev libusb-1.0-0-dev libjxr-dev libgtk2.0-0 mesa-vulkan-drivers gcc-mingw-w64 \
pkg-config mesa-utils

RUN add-apt-repository 'deb http://deb.debian.org/debian buster-backports main'
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y checkinstall libfaudio-dev

RUN cd / && wget "http://www.opensound.com/release/oss-linux-v4.2-2020-amd64.deb"
RUN dpkg -i /oss-linux-v4.2-2020-amd64.deb

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd

USER root

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key

RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main'

RUN echo "deb-src https://dl.winehq.org/wine-builds/debian/ buster main" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update
ARG VERSION="6.20"
ARG WINE_VERSION="${VERSION}~buster"
ARG WINE_DEB_VERSION="${WINE_VERSION}-1"

RUN DEBIAN_FRONTEND=noninteractive apt build-dep -y wine="${WINE_DEB_VERSION}"

RUN git clone -b "wine-${VERSION}" git://source.winehq.org/git/wine.git /usr/src/wine-source
RUN git clone -b "v${VERSION}" https://github.com/wine-staging/wine-staging.git /usr/src/wine-staging
RUN mkdir -p /usr/src/wine64

WORKDIR /usr/src/wine-staging/patches
RUN exec /bin/bash -c './patchinstall.sh DESTDIR=/usr/src/wine-source --all --force-autoconf'

WORKDIR /usr/src/wine64

RUN exec /bin/bash -c 'PKG_CONFIG_PATH=/usr/lib/pkgconfig ../wine-source/configure --enable-win64 --prefix=/opt/wine-staging'
RUN exec /bin/bash -c 'make -j7'

FROM i386/debian:buster-slim as i386

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget gnupg2 software-properties-common libvulkan* \
fakeroot dh-make git libasound2-dev libdbus-1-dev libfontconfig-dev libfreetype6-dev libgnutls28-dev libpng-dev \
libtiff-dev libgl-dev libunwind-dev libxml2-dev libxslt1-dev libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev libmpg123-dev libosmesa6-dev libsdl2-dev libudev-dev libvulkan-dev \
ocl-icd-opencl-dev libusb-1.0-0-dev libjxr-dev libgtk2.0-0 mesa-vulkan-drivers gcc-mingw-w64 \
pkg-config mesa-utils

RUN add-apt-repository 'deb http://deb.debian.org/debian buster-backports main'
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y checkinstall libfaudio-dev

RUN cd / && wget "http://www.opensound.com/release/oss-linux-v4.2-2020-i386.deb"
RUN dpkg -i /oss-linux-v4.2-2020-i386.deb

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd

USER root

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key

RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main'

RUN echo "deb-src https://dl.winehq.org/wine-builds/debian/ buster main" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update
ARG VERSION="6.20"
ARG WINE_VERSION="${VERSION}~buster"
ARG WINE_DEB_VERSION="${WINE_VERSION}-1"

RUN DEBIAN_FRONTEND=noninteractive apt build-dep -y wine="${WINE_DEB_VERSION}"

RUN mkdir -p /usr/src/wine32 /usr/src/wine32-tools
COPY --from=amd64 /usr/src/wine-source /usr/src/wine-source
COPY --from=amd64 /usr/src/wine64 /usr/src/wine64

WORKDIR /usr/src/wine32-tools

RUN exec /bin/bash -c 'PKG_CONFIG_PATH=/usr/lib/pkgconfig ../wine-source/configure'
RUN exec /bin/bash -c 'make -j7'

WORKDIR /usr/src/wine32

RUN exec /bin/bash -c 'PKG_CONFIG_PATH=/usr/lib/pkgconfig ../wine-source/configure --with-wine64=../wine64 --with-wine-tools=../wine32-tools --prefix=/opt/wine-staging'
RUN exec /bin/bash -c 'make -j7'
RUN exec /bin/bash -c 'checkinstall -D --pkgname=wine-local --pkgversion="${VERSION}" --nodoc --install=yes'

FROM debian:buster-slim

RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget gnupg2 software-properties-common libvulkan* \
libasound2-dev libdbus-1-dev libfontconfig-dev libfreetype6-dev libgnutls28-dev libpng-dev \
libtiff-dev libgl-dev libunwind-dev libxml2-dev libxslt1-dev libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev libmpg123-dev libosmesa6-dev libsdl2-dev libudev-dev libvulkan-dev \
ocl-icd-opencl-dev libusb-1.0-0-dev libjxr-dev libgtk2.0-0 mesa-vulkan-drivers gcc-mingw-w64 \
cabextract pkg-config \
sudo procps curl cabextract wget software-properties-common winbind libvulkan1 vulkan-utils xterm apt-utils \
zenity libnss3 p7zip p7zip-full sed xvfb vim mesa-utils

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libasound2-dev:i386 libdbus-1-dev:i386 libfontconfig-dev:i386 \
libfreetype6-dev:i386 libgnutls28-dev:i386 libpng-dev:i386 libtiff-dev:i386 libgl-dev:i386 libunwind-dev:i386 \
libxml2-dev:i386 libxslt1-dev:i386 libgstreamer1.0-dev:i386 libgstreamer-plugins-base1.0-dev:i386 libmpg123-dev:i386 \
libosmesa6-dev:i386 libsdl2-dev:i386 libudev-dev:i386 libvulkan-dev:i386 ocl-icd-opencl-dev:i386 libusb-1.0-0-dev:i386 \
libjxr-dev:i386 libgtk2.0-0:i386 mesa-vulkan-drivers:i386 pkg-config:i386

RUN add-apt-repository 'deb http://deb.debian.org/debian buster-backports main'
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y checkinstall libfaudio-dev

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd

USER root

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key

RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main'

RUN echo "deb-src https://dl.winehq.org/wine-builds/debian/ buster main" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update
ARG VERSION="6.20"
ARG WINE_VERSION="${VERSION}~buster"
ARG WINE_DEB_VERSION="${WINE_VERSION}-1"

RUN DEBIAN_FRONTEND=noninteractive apt build-dep -y wine="${WINE_DEB_VERSION}"

RUN cd /usr/bin && wget  'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks'
RUN chmod +x /usr/bin/winetricks

WORKDIR /home/ubuntu

COPY --from=amd64 /oss-linux-v4.2-2020-amd64.deb /home/ubuntu/.
COPY --from=amd64 /usr/src/wine-source /home/ubuntu/wine-source
COPY --from=amd64 /usr/src/wine64 /home/ubuntu/wine64
COPY --from=i386 /opt/wine-staging /opt/wine-staging
COPY --from=i386 /lib /lib

USER root

RUN dpkg -i oss-linux-v4.2-2020-amd64.deb

WORKDIR /home/ubuntu/wine64

RUN exec /bin/bash -c 'checkinstall -D --pkgname=wine-local --pkgversion="${VERSION}" --nodoc --install=yes'

WORKDIR /home/ubuntu

RUN rm -fr *.deb
RUN rm -fr wine*

RUN ln -s /opt/wine-staging/bin/wine64 /usr/bin/wine64
RUN ln -s /opt/wine-staging/bin/wine /usr/bin/wine
RUN ln -s /opt/wine-staging/bin/wineserver /usr/bin/wineserver

ENV HOME_PATH="/home/ubuntu"
ENV WINE_PATH="${HOME_PATH}/.wine"
ENV ARCHITECTURE="win64"
ENV WINE="wine64"

RUN rm -rf /var/lib/apt/lists/*

USER ubuntu

RUN echo "export HOME_PATH=${HOME_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE_PATH=${WINE_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export ARCHITECTURE=${ARCHITECTURE}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE=${WINE}" >> "${HOME_PATH}/.bashrc"
