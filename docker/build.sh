#!/bin/bash

# NOTE: copied from https://github.com/debezium/docker-images/blob/master/build-debezium.sh
# need to change to our docker hub id
DOCKER_HUB_USER="eqzrg9mev6jfznm"
IMAGE_VERSION=$1

echo_run() {
  cmd=$1
  echo "--- RUN $cmd"
  eval $cmd
}


#
# Parameter 1: image name
# Parameter 2: path to component (if different)
#
build_docker_image () {
    IMAGE_NAME="$1"
    IMAGE_PATH="$2"
    if [ -z "$IMAGE_PATH" ]; then
        IMAGE_PATH=${IMAGE_NAME};
    fi

    echo ""
    echo "****************************************************************"
    echo "** Building  $DOCKER_HUB_USER/${IMAGE_NAME}:${IMAGE_VERSION}"
    echo "****************************************************************"


    # build two versions
    REMOTE_IMAGE="$DOCKER_HUB_USER/$IMAGE_NAME"
    echo_run "docker build -t $REMOTE_IMAGE:latest -t $REMOTE_IMAGE:$IMAGE_VERSION    $IMAGE_PATH/$IMAGE_VERSION"
    echo_run "docker tag $REMOTE_IMAGE   $REMOTE_IMAGE:$IMAGE_VERSION"
    echo_run "docker push $REMOTE_IMAGE"


    if [ $? -ne 0 ]; then
        exit $?;
    fi
}


if [[ -z "$1" ]]; then
    echo ""
    echo "A version must be specified."
    echo ""
    echo "Usage:  build.sh <version>";
    echo ""
    exit 1;
fi


build_docker_image mysql

echo ""
echo "**********************************"
echo "Successfully created Docker images"
echo "**********************************"
echo ""
