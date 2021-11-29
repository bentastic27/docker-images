#!/bin/bash

repo=bentastic27/minecraft

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag $repo:$(git log -1 --format="%H") \
  --tag $repo:latest \
  --push .
