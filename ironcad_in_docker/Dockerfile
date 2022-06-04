FROM archlinux:latest

RUN  echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Syu --noconfirm base-devel sudo git vulkan-tools vulkan-validation-layers vulkan-headers vulkan-radeon \
nvidia-utils vulkan-intel cabextract p7zip samba wget curl vim
RUN useradd user -G wheel && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /usr/src

RUN git clone https://github.com/Frogging-Family/wine-tkg-git
RUN cd wine-tkg-git
WORKDIR /usr/src/wine-tkg-git

RUN chown user -R .

USER user

RUN sed '/_hotfix="EGS" _hotfix_boundary="" _hotfix_import/d' wine-tkg-git/wine-tkg-patches/hotfixes/hotfixer

WORKDIR /usr/src/wine-tkg-git/wine-tkg-git

RUN sed -i "/'jack2'                 'lib32-jack2'/d" PKGBUILD
RUN sed -i "/'gst-plugins-good'      'lib32-gst-plugins-good'/d" PKGBUILD
RUN bash -c 'yes | PKGDEST=/tmp/wine-tkg makepkg --noconfirm -s'

ENV HOME_PATH="/home/user"
ENV WINE_PATH="${HOME_PATH}/.ironcad"
ENV ARCHITECTURE="win64"
ENV WINE="wine64"

USER root

RUN cd /usr/bin && wget  'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks'
RUN chmod +x /usr/bin/winetricks

WORKDIR /home/user
RUN chown -R user /home/user

RUN touch /home/user/.bashrc
RUN chown user /home/user/.bashrc
RUN pacman -U --noconfirm /tmp/wine-tkg/wine-tkg-staging-fsync-git*.pkg.tar.zst
RUN rm -fr /tmp/*
RUN rm -fr /usr/src/wine-tkg-git

USER user

COPY ${PWD}/ironcad_in_docker/install_ironcad.sh .
RUN chown user install_ironcad.sh
RUN chmod +x install_ironcad.sh

# Download IronCAD 2019 from www.ironcad.com
# https://community.ironcad.com/index.php?/files/file/13-ironcad-2019-release-version/
COPY ${PWD}/ironcad_in_docker/IronCADDCS2019x64.exe .
RUN chown user IronCADDCS2019x64.exe
RUN chmod +x IronCADDCS2019x64.exe

RUN echo "export HOME_PATH=${HOME_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE_PATH=${WINE_PATH}" >> "${HOME_PATH}/.bashrc"
RUN echo "export ARCHITECTURE=${ARCHITECTURE}" >> "${HOME_PATH}/.bashrc"
RUN echo "export WINE=${WINE}" >> "${HOME_PATH}/.bashrc"
