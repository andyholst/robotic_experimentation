FROM ros:foxy

RUN apt-get update
RUN apt install -y wget

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN cat /etc/apt/sources.list.d/gazebo-stable.list
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y gazebo11 libgazebo11-dev
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /ros2_home/src

WORKDIR /ros2_home/src