FROM ubuntu:20.04

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl cabextract wget software-properties-common winbind \
libvulkan1 libvulkan1:i386 libvulkan-dev vulkan-utils sudo xterm apt-utils zenity libnss3 libgst-dev libudev-dev \
p7zip p7zip-full p7zip-rar sed xvfb vim mesa-utils

RUN add-apt-repository ppa:kisak/kisak-mesa
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN apt update
RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'

ARG WINE_VERSION="5.7~focal"
RUN DEBIAN_FRONTEND=noninteractive apt install -y winehq-staging="${WINE_VERSION}" wine-staging="${WINE_VERSION}" \
wine-staging-amd64="${WINE_VERSION}" wine-staging-i386="${WINE_VERSION}"
RUN DEBIAN_FRONTEND=noninteractive apt install -y winetricks

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd

WORKDIR /home/ubuntu

RUN rm -rf /var/lib/apt/lists/*

USER ubuntu

ENV HOME_PATH="/home/ubuntu"
ENV WINE_PATH="${HOME_PATH}/.fusion360"
ENV ARCHITECTURE="win64"
ENV WINE="wine64"

RUN wget -O fusion360.exe -nc \
"https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Admin%20Install.exe" && \
7z x -osetup/ fusion360.exe && rm fusion360.exe

USER root

COPY ${PWD}/fusion360_in_docker/install_fusion360.sh .
RUN chown ubuntu install_fusion360.sh
RUN chmod +x install_fusion360.sh

COPY ${PWD}/fusion360_in_docker/watch_fusion360_install_proccess.sh .
RUN chown ubuntu watch_fusion360_install_proccess.sh
RUN chmod +x watch_fusion360_install_proccess.sh

USER ubuntu

RUN echo "export HOME_PATH=${HOME_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE_PATH=${WINE_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export ARCHITECTURE=${ARCHITECTURE}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE=${WINE}" >> "${HOME_PATH}/.bashrc"
RUN echo "export LANG=en_US.UTF-8" >> "${HOME_PATH}/.bashrc"
RUN echo "export LANGUAGE=en_US.UTF-8" >> "${HOME_PATH}/.bashrc"