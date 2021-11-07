FROM archlinux:base-devel-20211017.0.36769

# Replace Vulkan child window support with patch needed to use 3D CAD applications with DirectX 11/9 to Vulkan
# transformation rendering
# https://github.com/Frogging-Family/wine-tkg-git/issues/358
# https://github.com/Frogging-Family/wine-tkg-git/commit/d215bb734dd41274105703378043fe4130abfed7

RUN  echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Syu --noconfirm base-devel sudo git vulkan-tools vulkan-validation-layers vulkan-headers vulkan-radeon \
nvidia-utils vulkan-intel cabextract
RUN useradd winer -G wheel && echo "winer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /usr/src

RUN git clone https://github.com/Frogging-Family/wine-tkg-git

WORKDIR /usr/src/wine-tkg-git

RUN chown winer -R .

USER winer

WORKDIR /usr/src/wine-tkg-git/wine-tkg-git

RUN sed -i "/'jack2'                 'lib32-jack2'/d" PKGBUILD
RUN sed -i "/'gst-plugins-good'      'lib32-gst-plugins-good'/d" PKGBUILD
RUN bash -c 'yes | PKGDEST=/tmp/wine-tkg makepkg --noconfirm -s'

ENV HOME_PATH="/home/winer"
ENV WINE_PATH="${HOME_PATH}/.ironcad"
ENV ARCHITECTURE="win64"
ENV WINE="wine64"

USER root

RUN cd /usr/bin && wget  'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks'
RUN chmod +x /usr/bin/winetricks

WORKDIR /home/winer
RUN chown -R winer /home/winer

COPY ${PWD}/ironcad_in_docker/install_ironcad.sh .
RUN chown winer install_ironcad.sh
RUN chmod +x install_ironcad.sh

# Download IronCAD 2019 from www.ironcad.com
# https://community.ironcad.com/index.php?/files/file/13-ironcad-2019-release-version/
COPY ${PWD}/ironcad_in_docker/IronCADDCS2019_x64.exe .
RUN chown winer IronCADDCS2019_x64.exe
RUN chmod +x IronCADDCS2019_x64.exe

RUN touch /home/winer/.bashrc
RUN chown winer /home/winer/.bashrc
RUN pacman -U --noconfirm /tmp/wine-tkg/wine-tkg-staging-fsync-git*.pkg.tar.zst
RUN rm -fr /tmp/*
RUN rm -fr /usr/src/wine-tkg-git

USER winer

RUN echo "export HOME_PATH=${HOME_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE_PATH=${WINE_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export ARCHITECTURE=${ARCHITECTURE}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE=${WINE}" >> "${HOME_PATH}/.bashrc"
