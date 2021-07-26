FROM ros:foxy

RUN mkdir /ros2_home/src

WORKDIR /ros2_home

CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener.launch.py"]