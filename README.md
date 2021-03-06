# ROS2

## To refresh internet configuration settings for Docker in Debian if internet connection is lost from a Docker build

```bash
pkill docker
iptables -t nat -F
ifconfig docker0 down
brctl delbr docker0
docker -d
```

## Create a new ROS2 python package
```bash
docker run -v ${PWD}:/src ros:foxy bash -c "cd src && \
ros2 pkg create --build-type ament_python --node-name robot_node robot_prototype"
```

## Run newly created robot package
```bash
docker build -f robot_prototype/Dockerfile -t robot .
docker run robot_prototype
```

## Run the robot prototype package in ROS2 platform container
```bash
docker build -f Dockerfile -t robot-with-ros2 .
docker run --rm -v ${PWD}/robot_prototype:/ros2_home/src/robot_prototype robot-with-ros2 bash -c "colcon build \
--packages-select robot_prototype && . install/local_setup.bash && \
ros2 launch robot_prototype robot_prototype_launch.py"
```

## Run Gazebo inside ROS2 container

```bash
xhost +
docker build -f Dockerfile -t robot-with-ros2 .
docker run -it \
--device=/dev/dri \
--group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--env="DISPLAY=$DISPLAY" \
--name gazebo-simulation-with-ros2 \
robot-with-ros2 gazebo \
gazebo
```

## Modeling with Blender in Docker
```bash
xhost +
docker build -f blender_in_docker/Dockerfile -t blender-in-docker .
docker run -it \
-v ${PWD}/models:/models \
--device=/dev/dri \
--group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--env="DISPLAY=$DISPLAY" \
--name blender \
blender-in-docker \
blender
```

## Modeling with Fusion360 in Docker
```bash
xhost +
docker build -f fusion360_in_docker/Dockerfile -t fusion360-in-docker .
docker run -it \
-v ${PWD}/models:/models \
--device=/dev/dri \
--group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--env="DISPLAY=$DISPLAY" \
--name install-fusion360 \
fusion360-in-docker

# Inside the container at the ubuntu home directory execute the following commands
./install_fusion360.sh # Saved the container state after this with 'docker commit container-hash name-of-image' to work with 3d models
source ~/.bashrc # Source the latest environment variables made in the watch_fusion360_install_proccess.sh script

#  Fusion 360 in WINE works best with DirectX 9 or OpenGL, is set to 'DirectX 9 is set by default if vulkan version 
#  d9vk is installed'.
#  You might need to change graphic rendering driver from auto to 'DirectX 9'/OpenGL to get the rendering working
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} "${FUSION_360_EXE}" 
```
# Save the container state to be able to smoothly work with 3d models afterwards
```bash
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} "${FUSION_360_EXE}"
```

## Modeling with IronCad in Docker

```bash
xhost +
docker build -f ironcad_in_docker/Dockerfile -t ironcad-in-docker .

docker run -it --rm \
-v ${PWD}/models:/models \
--device=/dev/dri \
--group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--env="DISPLAY=$DISPLAY" \
--name install-ironcad \
ironcad-in-docker

# Inside the container at the ubuntu home directory execute the following commands
sudo ./install_ironcad.sh

# Then start IronCAD with command:
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} \
"${WINE_PATH}"/drive_c/Program\ Files/IronCAD/2019/bin/IRONCAD.exe
```

## Compile WINE i386/amd64 in Docker

Dockerfile that compiles WINE version 6.19 from source with necessary development dependencies included for both
i386 and amd64 architecture in a Debian buster distro environment.

```bash
xhost +
docker build -f wine_from_source/Dockerfile -t wine-in-docker .
docker run -it \
-v ${PWD}/models:/models \
--device=/dev/dri \
--group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--env="DISPLAY=$DISPLAY" \
--name install-wine-from-source \
wine-in-docker
```