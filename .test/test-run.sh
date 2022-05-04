#!/bin/bash
FOLDER=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# initializing variables
DOCKER_CONTAINER_NAME="my-ansible-test-ubuntu"
DOCKER_IMAGE_NAME="ansible-test-ubuntu"

# clean up old runs
docker stop "$DOCKER_CONTAINER_NAME"
docker rm "$DOCKER_CONTAINER_NAME"

# Exit on error from here on
set -euo pipefail

# building and running the docker image
docker build -t "$DOCKER_IMAGE_NAME" "$FOLDER/docker/"
docker run --name "$DOCKER_CONTAINER_NAME" -d -v "$FOLDER/..:/playbook" -v /sys/fs/cgroup:/sys/fs/cgroup --privileged "$DOCKER_IMAGE_NAME"

docker exec "$DOCKER_CONTAINER_NAME" /playbook/run.sh "Docker!" "--skip-tags" "prod"

# stopping and removing the container
docker stop "$DOCKER_CONTAINER_NAME" && docker rm "$DOCKER_CONTAINER_NAME"
