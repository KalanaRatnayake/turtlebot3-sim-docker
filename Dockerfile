# Start with the base image
FROM ros:jazzy-ros-base-noble

# Set environment variables for ROS
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends ros-dev-tools \
                                                ros-$ROS_DISTRO-tf2-eigen \
                                                ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
                                                ros-$ROS_DISTRO-turtlebot3* \
                                                ros-jazzy-desktop \
                                                python3-rosdep \
                                                python3-rosinstall-generator \
                                                build-essential

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN apt-get clean

# Initialize rosdep
RUN rosdep init && \
    rosdep update

ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py