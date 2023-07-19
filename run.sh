#!/bin/bash

GRAFANA_IMAGE="docker.io/grafana/grafana:9.5.6"
GRAFANA_DATAPATH="/var/lib/grafana"

INFLUXDB_IMAGE="docker.io/influxdb:2.7.0"
INFLUXDB_DATAPATH="/var/lib/influxdb2"

INFLUX_URL="http://host.containers.internal:8086"

TELEGRAF_IMAGE="docker.io/telegraf:1.9"
TELEGRAF_CONFIG="$PWD/telegraf.conf"

# Load secrets
. secret.conf

# stop
podman stop grafana > /dev/null 2>&1
podman stop influxdb > /dev/null 2>&1
podman stop telegraf > /dev/null 2>&1


# run influxdb
#  -e "INFLUXDB_HTTP_ENABLED=true" \
#  -e "INFLUXDB_HTTP_AUTH_ENABLED=true" \
mkdir "$INFLUXDB_DATAPATH" > /dev/null 2>&1
podman run -p 8086:8086 --name=influxdb -d \
  --rm \
  --user "$(id -u)" \
  --volume "$INFLUXDB_DATAPATH:/var/lib/influxdb2" \
  "$INFLUXDB_IMAGE" \
  --reporting-disabled

# run telegraf
#  -p 8125:8125/udp -p 8092:8092/udp -p 8094:8094
podman run --name=telegraf -d \
  --rm \
  --user "$(id -u)" \
  -v "$TELEGRAF_CONFIG":/etc/telegraf/telegraf.conf:ro \
  -v /:/hostfs:ro \
  -e HOST_ETC=/hostfs/etc \
  -e HOST_PROC=/hostfs/proc \
  -e HOST_SYS=/hostfs/sys \
  -e HOST_VAR=/hostfs/var \
  -e HOST_RUN=/hostfs/run \
  -e HOST_MOUNT_PREFIX=/hostfs \
  -e INFLUX_URL="$INFLUX_URL" \
  -e INFLUX_TOKEN="$INFLUX_TOKEN" \
  -e HOSTNAME="$HOSTNAME" \
  -v /var/run/podman/podman.sock:/var/run/podman/podman.sock \
  "$TELEGRAF_IMAGE"

# run grafana
#  -e "GF_PATHS_CONFIG=/var/lib/grafana/grafana.ini" \
mkdir "$GRAFANA_DATAPATH" > /dev/null 2>&1
podman run -p 3000:3000 --name=grafana -d \
  --rm \
  --user "$(id -u)" \
  --volume "$GRAFANA_DATAPATH:/var/lib/grafana" \
  "$GRAFANA_IMAGE"

