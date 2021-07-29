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
docker run --rm -v ${PWD}/robot_prototype:/ros2_home/src/robot_prototype robot-with-ros2
```