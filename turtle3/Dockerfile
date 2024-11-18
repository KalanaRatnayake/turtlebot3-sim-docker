# Start with the base image
FROM ros:jazzy-ros-base-noble as base

# Set environment variables for ROS
ENV WORKSPACE_ROOT=/turtlebot3_ws
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends ros-dev-tools \
    ros-$ROS_DISTRO-tf2-eigen \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
    ros-$ROS_DISTRO-desktop \
    python3-rosdep \
    python3-rosinstall-generator \
    build-essential \
    ros-$ROS_DISTRO-ros-gz-dev \
    ros-$ROS_DISTRO-ros-gz

RUN apt-get clean

#############################################################################################################################
#####
#####   Clone packages and setup dependencies
#####
#############################################################################################################################

WORKDIR ${WORKSPACE_ROOT}/src

RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3.git -b humble-devel
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git -b humble-devel
RUN git clone https://github.com/ros-simulation/gazebo_ros_pkgs.git -b ros2

RUN rm /etc/ros/rosdep/sources.list.d/20-default.list

RUN rosdep init && rosdep update && rosdep install --from-paths ${WORKSPACE_ROOT}/src -y --ignore-src

#############################################################################################################################
#####
#####   Build Capabilities packages
#####
#############################################################################################################################

WORKDIR ${WORKSPACE_ROOT}

RUN . /opt/ros/jazzy/setup.sh && colcon build

WORKDIR /

#############################################################################################################################
#####
#####   Remove workspace source and build files that are not relevent to running the system
#####
#############################################################################################################################

RUN rm -rf ${WORKSPACE_ROOT}/src
RUN rm -rf ${WORKSPACE_ROOT}/log
RUN rm -rf ${WORKSPACE_ROOT}/build

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------


FROM ros:jazzy-ros-base-noble as final

## Parameters
ENV WORKSPACE_ROOT=/turtlebot3_ws
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle

COPY --from=base / /

COPY workspace_entrypoint.sh /workspace_entrypoint.sh

RUN chmod +x /workspace_entrypoint.sh

ENTRYPOINT [ "/workspace_entrypoint.sh" ]

CMD ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py