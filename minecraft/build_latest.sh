#!/bin/bash

manifest_data=$(curl https://launchermeta.mojang.com/mc/game/version_manifest_v2.json)
latest_release=$(echo $manifest_data | jq -r '.latest.release')
latest_release_url=$(echo $manifest_data | jq -r ".versions[] | select(.id == \"${latest_release}\") | .url")
server_download_url=$(curl $latest_release_url | jq -r '.downloads.server.url')

docker build . -t bentastic27/minecraft:$latest_release --build-arg server_download_url=$server_download_url
docker tag bentastic27/minecraft:$latest_release bentastic27/minecraft:latest