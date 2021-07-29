FROM ros:foxy

RUN mkdir -p /ros2_home/src

WORKDIR /ros2_home/src

CMD ["bash", "-c", "colcon build --packages-select robot_prototype && \
. install/local_setup.bash && \
ros2 launch robot_prototype robot_prototype_launch.py && \
tail -f /dev/null"]