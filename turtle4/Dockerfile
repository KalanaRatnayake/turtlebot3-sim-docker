# Start with the base image
FROM ros:jazzy-ros-base-noble as base

# Set environment variables for ROS
ENV WORKSPACE_ROOT=/turtlebot4_ws
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends ros-dev-tools \
    ros-$ROS_DISTRO-tf2-eigen \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
    ros-$ROS_DISTRO-desktop \
    python3-rosdep \
    python3-rosinstall-generator \
    build-essential

RUN apt-get clean

#############################################################################################################################
#####
#####   Clone packages and setup dependencies
#####
#############################################################################################################################

WORKDIR ${WORKSPACE_ROOT}/src

RUN git clone https://github.com/turtlebot/turtlebot4_simulator.git -b jazzy
RUN git clone https://github.com/iRobotEducation/create3_sim.git -b jazzy

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
ENV WORKSPACE_ROOT=/turtlebot4_ws
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

COPY --from=base / /

COPY workspace_entrypoint.sh /workspace_entrypoint.sh

RUN chmod +x /workspace_entrypoint.sh

ENTRYPOINT [ "/workspace_entrypoint.sh" ]

CMD ros2 launch turtlebot4_gz_bringup turtlebot4_gz.launch.py