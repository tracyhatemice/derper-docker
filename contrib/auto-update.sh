#!/bin/bash

ONLINE_DERP_VERSION=$(wget -q -O - https://api.github.com/repos/tracyhatemice/derper-docker/releases/latest | jq -r '.tag_name' | sed 's/^v//')
echo "Latest Derp version: $ONLINE_DERP_VERSION"

# Example output: 1.90.1-ERR-BuildInfo
LOCATAL_DERP_VERSION=$(/usr/local/bin/derper -version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
echo "Local Derp version: $LOCATAL_DERP_VERSION"

if [ "$ONLINE_DERP_VERSION" = "$LOCATAL_DERP_VERSION" ]; then
    echo "Derp is up to date."
    exit 0
fi

echo "Updating Derp to version $ONLINE_DERP_VERSION"
wget -qO derper_v"$ONLINE_DERP_VERSION"_linux_amd64.tar.xz https://github.com/tracyhatemice/derper-docker/releases/download/v"$ONLINE_DERP_VERSION"/derper_v"$ONLINE_DERP_VERSION"_linux_amd64.tar.xz

sudo systemctl stop derper
sudo tar xfJ derper_v"$ONLINE_DERP_VERSION"_linux_amd64.tar.xz -C /usr/local/bin/
sudo chmod 755 /usr/local/bin/derper
rm derper_v"$ONLINE_DERP_VERSION"_linux_amd64.tar.xz
sudo systemctl start derper

echo "Derp has been updated to version $ONLINE_DERP_VERSION"

