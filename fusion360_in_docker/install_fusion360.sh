#!/usr/bin/env bash

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" WINEDLLOVERRIDES="mscoree,mshtml=" wine wineboot

wget -nc "https://github.com/madewokherd/wine-mono/releases/download/wine-mono-6.3.0/wine-mono-6.3.0-x86.msi"
wget -nc "http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi"

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} msiexec /i wine-mono-6.3.0-x86.msi
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} msiexec /i wine-gecko-2.47.2-x86_64.msi

rm wine-mono-6.3.0-x86.msi
rm wine-gecko-2.47.2-x86_64.msi

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q atmlib
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q gdiplus
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q corefonts
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q fontsmooth=rgb
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q winhttp
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q vcrun2017
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q d9vk
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q win10
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks vcruntime140_1=native

touch log.txt
./watch_fusion360_install_proccess.sh &
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} "${HOME}/setup/streamer.exe" -p deploy -g -f log.txt --quiet
