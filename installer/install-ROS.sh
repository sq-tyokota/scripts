#!/bin/bash
# install ROS

DIST=kinetic

echo "install ROS ${DIST}"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

sudo apt-get update
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
sudo apt-get install -y ros-${DIST}-desktop
# sudo c_rehash /etc/ssl/certs

sudo rosdep init
rosdep update

echo "source /opt/ros/${DIST}/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt-get install -y python-rosinstall

echo 'setup workspace'
source /opt/ros/${DIST}/setup.bash

#install dep 
sudo apt-get install ros-${DIST}-urg-node ros-${DIST}-pcl-ros ros-${DIST}-pcl-conversions
rospack profile

DEFAULTDIR=~/sq_ws # if you are not sq-member, you change this ws name
echo "$DEFAULTDIR"/src
mkdir -p "$DEFAULTDIR"/src
cd "$DEFAULTDIR"/src
catkin_init_workspace
cd "$DEFAULTDIR"
catkin_make
echo "source ${DEFAULTDIR}/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
