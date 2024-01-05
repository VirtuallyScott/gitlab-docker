#!/bin/bash

# Function to log into a Docker registry
login_to_registry() {
  local registry_url=$1
  local username=$2
  local password=$3

  echo "Logging into Docker registry $registry_url"
  echo "$password" | docker login --username "$username" --password-stdin "$registry_url"
  if [ $? -ne 0 ]; then
    echo "Error: Login to Docker registry $registry_url failed"
    exit 1
  fi
}

# Function to pull a Docker image from a registry
pull_image() {
  local image=$1

  echo "Pulling Docker image $image"
  docker pull "$image"
  if [ $? -ne 0 ]; then
    echo "Error: Pulling Docker image $image failed"
    exit 1
  fi
}

# Function to tag a Docker image for a new registry
tag_image() {
  local source_image=$1
  local target_image=$2

  echo "Tagging Docker image $source_image as $target_image"
  docker tag "$source_image" "$target_image"
  if [ $? -ne 0 ]; then
    echo "Error: Tagging Docker image $source_image as $target_image failed"
    exit 1
  fi
}

# Function to push a Docker image to a registry
push_image() {
  local image=$1

  echo "Pushing Docker image $image"
  docker push "$image"
  if [ $? -ne 0 ]; then
    echo "Error: Pushing Docker image $image failed"
    exit 1
  fi
}

# Error handling
trap 'catch $?' EXIT

catch() {
  if [ "$1" != "0" ]; then
    echo "Error: Script encountered an error"
    exit 1
  fi
}

# Main script execution
# Replace the following variables with appropriate values
REGISTRY_X_URL="registry.x.com"
REGISTRY_Y_URL="registry.y.com"
REGISTRY_X_USERNAME="user_x"
REGISTRY_X_PASSWORD="pass_x"
REGISTRY_Y_USERNAME="user_y"
REGISTRY_Y_PASSWORD="pass_y"
IMAGE_X="registry.x.com/image:tag"
IMAGE_Y="registry.y.com/image:tag"

# Log into Docker registry X
login_to_registry "$REGISTRY_X_URL" "$REGISTRY_X_USERNAME" "$REGISTRY_X_PASSWORD"

# Log into Docker registry Y
login_to_registry "$REGISTRY_Y_URL" "$REGISTRY_Y_USERNAME" "$REGISTRY_Y_PASSWORD"

# Pull the image from registry X
pull_image "$IMAGE_X"

# Tag the image with registry Y
tag_image "$IMAGE_X" "$IMAGE_Y"

# Push the image to registry Y
push_image "$IMAGE_Y"

echo "Docker operations completed successfully"