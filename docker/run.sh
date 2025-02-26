#!/bin/sh

usage() { echo "Usage: $0 [-t <tag>] [-i <image>]" 1>&2; exit 1; }

# Defaults
DOCKER_IMAGE_NAME="carla-ros-bridge"
TAG="foxy"

while getopts ":ht:i:" opt; do
  case $opt in
    h)
      usage
      exit
      ;;
    t)
      TAG=$OPTARG
      ;;
    i)
      DOCKER_IMAGE_NAME=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

echo "Using $DOCKER_IMAGE_NAME:$TAG"

# docker run \
#     -it --rm \
#     --net=host \
#     "$DOCKER_IMAGE_NAME:$TAG" "$@"


# docker run \
#     -it --rm \
#     --net=host \
#     -e DISPLAY=$DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#     "$DOCKER_IMAGE_NAME:$TAG" "$@"

# docker run \
#     -it --rm \
#     --network=host \
#     --ipc=host \
#     -e DISPLAY=$DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#     -v /home/chirag/carla_ws/src/ros-bridge/docker/content/dds.xml:/home/chirag/carla_ws/src/ros-bridge/docker/content/dds.xml \
#     -e XDG_SESSION_TYPE=x11 \
#     "$DOCKER_IMAGE_NAME:$TAG" "$@"



docker run \
    -it --rm \
    --ipc=host \
    --net=host \
    --gpus all \
    --user root \
    -e DISPLAY=$DISPLAY \
    -v /dev/shm:/dev/shm \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /home/chirag/carla_ws/src/ros-bridge/docker/content/dds.xml:/home/chirag/carla_ws/src/ros-bridge/docker/content/dds.xml \
    --runtime=nvidia \
    -e RMW_IMPLEMENTATION=rmw_cyclonedds_cpp \
    -e FASTRTPS_DEFAULT_PROFILES_FILE=/home/chirag/carla_ws/src/ros-bridge/docker/content/dds.xml \
    -e ROS_DOMAIN_ID=31 \
    "$DOCKER_IMAGE_NAME:$TAG" "$@"

    # -e RMW_IMPLEMENTATION=rmw_fastrtps_cpp \
    # -e FASTRTPS_DEFAULT_PROFILES_FILE=/home/chirag/carla_ws/src/ros-bridge/docker/content/dds.xml> \

# docker run \
#   -it --rm \
#   --runtime=nvidia \
#   --net=host \
#   --env=DISPLAY=$DISPLAY \
#   --env=NVIDIA_VISIBLE_DEVICES=all \
#   --env=NVIDIA_DRIVER_CAPABILITIES=all \
#   --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#   "$DOCKER_IMAGE_NAME:$TAG" "$@"
