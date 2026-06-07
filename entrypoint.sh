#!/usr/bin/env bash

set -e

TEMPLATE_DIR="/home/steam/rs_server/templates"
CONFIG_DIR="/home/steam/rs_server/RSDragonwilds/Saved/Config/LinuxServer"

# Create config directory if it doesn't exist
mkdir -p ${CONFIG_DIR}

# Backup existing config if present
if [ -f "${CONFIG_DIR}/DedicatedServer.ini" ]; then
    cp ${CONFIG_DIR}/DedicatedServer.ini ${CONFIG_DIR}/DedicatedServer.ini.bak
fi

# Substitute environment variables into the template and write to config dir
envsubst < ${TEMPLATE_DIR}/DedicatedServer.ini > ${CONFIG_DIR}/DedicatedServer.ini

# Launch the server
exec /home/steam/rs_server/RSDragonwildsServer.sh -log -NewConsole -Port=7777