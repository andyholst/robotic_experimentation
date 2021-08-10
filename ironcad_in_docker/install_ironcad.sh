#!/usr/bin/env bash

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" WINEDLLOVERRIDES="mscoree,mshtml=" ${WINE} wineboot

wget -nc "https://github.com/madewokherd/wine-mono/releases/download/wine-mono-6.4.1/wine-mono-6.4.1-x86.msi"
wget -nc "http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi"

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} msiexec /i wine-mono-6.4.1-x86.msi
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} msiexec /i wine-gecko-2.47.2-x86_64.msi

rm wine-mono-6.4.1-x86.msi
rm wine-gecko-2.47.2-x86_64.msi

wineserver -k

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q d3dcompiler_47
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q dxvk
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q win10

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} IronCADDCS2019_x64.exe

# You might have to use super permissions or add permissions to the Vulkan library for being able to transform
# DirectX 9/11 to Vulkan rendering
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} \
"${WINE_PATH}"/drive_c/Program\ Files/IronCAD/2019/bin/IRONCAD.exe