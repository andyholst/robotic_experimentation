#!/usr/bin/env bash

sleep 15

fusion360Pid="$(ps -A | grep -i "streamer.exe" | head -1 | awk '{print $1}')"

running="True"
while [ "${running}" == "True" ]
do
  grep "##################################### End #####################################" log.txt
  if [[ $? -eq 0 ]]; then
    running="False"
    kill -9 "${fusion360Pid}"
  else
    echo "Still installing Fusion360"
    sleep 5
  fi
done

rm -fr "${HOME}/setup"
rm log.txt

FUSION_360_EXE="$(find "${WINE_PATH}" -name "FusionLauncher.exe.ini" | head -1 | xargs -I '{}' echo {} | head -c-5)"
FUSION_360_EXE="$(echo ${FUSION_360_EXE} | sed -e 's/Program Files/Program\\ Files/g')"
echo "export FUSION_360_EXE=${FUSION_360_EXE}" >> "${HOME_PATH}/.bashrc"
source "${HOME_PATH}/.bashrc"
