#!/bin/sh
cd /srv

function download_minecraft() {
  # if latest, then calculate latest, else go directly to url
  if [ $MINECRAFT_VERSION == "latest" ]; then
    release_url=$(get_manifest_data | jq -r ".versions[] | select(.id == \"$(echo $manifest_data | jq -r '.latest.release')\") | .url")
  else
    release_url=$(get_manifest_data | jq -r ".versions[] | select(.id == \"${MINECRAFT_VERSION}\") | .url")
  fi
  curl -so /srv/server.jar $(curl -s $release_url | jq -r '.downloads.server.url')
}

function get_manifest_data() {
  # save to tmp to allow new containers to upgrade via newer manifests
  if [ ! -f /tmp/manifest_data.json ]; then
    curl -so /tmp/manifest_data.json https://launchermeta.mojang.com/mc/game/version_manifest_v2.json
  fi
  cat /tmp/manifest_data.json
}

function get_latest() {
  get_manifest_data | jq -r '.latest.release'
}

function current_version() {
  unzip -p /srv/server.jar version.json | jq -r '.id'
}

# eula env required
if [ -z ${EULA} ] || [ ${EULA} != "true" ]; then
  echo "Accept EULA by setting the EULA variable to true"
  exit 1
else
  echo eula=true > eula.txt
fi

# calculate latest to actual version
echo "Using ${MINECRAFT_VERSION:=latest}"
if [ $MINECRAFT_VERSION == "latest" ]; then
  MINECRAFT_VERSION=$(get_latest)
  echo "MINECRAFT_VERSION set to latest, using ${MINECRAFT_VERSION}"
fi

# download if jar doesn't exist or version mismatch
if [ ! -f /srv/server.jar ]; then
  echo "Downloading minecraft"
  download_minecraft
elif [ $MINECRAFT_VERSION != $(current_version) ]; then
  echo "MINECRAFT_VERSION doesn't match current server version"
  echo "Downloading minecraft"
  download_minecraft
fi

java -Xmx${MAX_MEMORY_SIZE:=1G} -Xms${INIT_MEMORY_SIZE:=1G} -jar server.jar nogui
