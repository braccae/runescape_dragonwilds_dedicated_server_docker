#!/usr/bin/env bash

set -e

TEMPLATE_DIR="/home/steam/rs_server/templates"
CONFIG_DIR="/home/steam/rs_server/RSDragonwilds/Saved/Config/LinuxServer"
SAVED_GAMES_DIR="/home/steam/rs_server/RSDragonwilds/Saved/SaveGames"
GUID_FILE="${SAVED_GAMES_DIR}/server_guid.txt"

echo "Backing up existing config if present..."
if [ -f "${CONFIG_DIR}/DedicatedServer.ini" ]; then
    cp ${CONFIG_DIR}/DedicatedServer.ini ${CONFIG_DIR}/DedicatedServer.ini.bak
fi

# Check for existing ServerGuid in backup config and save it to SavedGames
if [ -f "${CONFIG_DIR}/DedicatedServer.ini.bak" ]; then
    EXISTING_GUID=$(grep -i '^ServerGuid=' "${CONFIG_DIR}/DedicatedServer.ini.bak" | cut -d'=' -f2- | tr -d '\r\n[:space:]')
    if [ -n "${EXISTING_GUID}" ]; then
        echo "Saving existing ServerGuid to ${GUID_FILE}..."
        echo "${EXISTING_GUID}" > "${GUID_FILE}"
    fi
fi

# Restore ServerGuid if not already set
if [ -z "${ServerGuid}" ] && [ -f "${GUID_FILE}" ]; then
    export ServerGuid=$(cat "${GUID_FILE}" | tr -d '\r\n[:space:]')
    echo "Restored ServerGuid from SavedGames: ${ServerGuid}"
fi

echo "Substituting environment variables into the template and writing to config dir..."
envsubst < ${TEMPLATE_DIR}/DedicatedServer.ini > ${CONFIG_DIR}/DedicatedServer.ini

echo "Correcting Permissions..."
chown -Rv steam:steam ${SAVED_GAMES_DIR}

echo "Launching Server..."
su -u steam -c "/home/steam/rs_server/RSDragonwildsServer.sh -log -NewConsole -Port=7777"