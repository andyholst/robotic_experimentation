# ROS2

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
install_fusion360.sh # Saved the container state after this with 'git commit container-hash name-of-image' to work with 3d models
WINEPREFIX="${WINE_PATH}" WINEARCH="${ARCHITECTURE}" ${WINE} "${FUSION_360_EXE}" #  Be sure to change graphic rendering driver from auto to 'DirectX 9'/OpenGL to get the rendering working
```