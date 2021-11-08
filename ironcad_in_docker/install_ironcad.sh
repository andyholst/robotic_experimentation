#!/usr/bin/env bash

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" WINEDLLOVERRIDES="mscoree,mshtml=" ${WINE} wineboot

wget -nc "https://github.com/madewokherd/wine-mono/releases/download/wine-mono-6.4.1/wine-mono-6.4.1-x86.msi"
wget -nc "http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi"

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} msiexec /i wine-mono-6.4.1-x86.msi
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} msiexec /i wine-gecko-2.47.2-x86_64.msi

rm wine-mono-6.4.1-x86.msi
rm wine-gecko-2.47.2-x86_64.msi

wineserver -k

WINEPREFIX=~/.wine32 WINEARCH=win32 winetricks -q ole32


# Create Win32 bottle
# modify arch=win32 to arch=win64
# /home/winer/.wine32/system.reg:#arch=win32
#/home/winer/.wine32/userdef.reg:#arch=win32
#/home/winer/.wine32/user.reg:#arch=win32
# Install DLLS ole32
# Download IronCad
WINEPREFIX=~/.wine32 WINEARCH=win32 wineboot



WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q msxml6
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q gdiplus
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q winhttp
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q vcrun2017
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q dotnet48
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q ole32
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q oleaut32
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q mdac28
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q d3dcompiler_47
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q dxvk
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" winetricks -q win10

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} IronCADDCS2019_x64.exe

# You might have to use super permissions or add permissions to the Vulkan library for being able to transform
# DirectX 9/11 to Vulkan rendering like 'chown -R root "${WINE_PATH}"', you are executing in container context so it's
# OK, but not on a host machine
# WINEDEBUG=+loaddll get dll dependencies to resolve missing dependencies

WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} \
"${WINE_PATH}"/drive_c/Program\ Files/IronCAD/2019/bin/IRONCAD.exe