FROM docker.io/cm2network/steamcmd:root-trixie

# USER root
RUN apt update && apt install -y --no-install-recommends \
    gettext-base \
    tini \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# USER steam

WORKDIR /home/steam/rs_server

RUN chown -Rv root:root /home/steam/steamcmd
RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/rs_server +login anonymous +app_update 4019830 +quit +validate

ENV OwnerId=
ENV WorldPassword=
ENV AdminPassword=
ENV ServerName=
ENV DefaultWorldName=

WORKDIR /home/steam/rs_server/templates
COPY DedicatedServer.ini DedicatedServer.ini
WORKDIR /home/steam/rs_server


VOLUME /home/steam/rs_server/RSDragonwilds/Saved/SaveGames
# VOLUME /home/steam/rs_server/RSDragonwilds/Plugins

# USER root
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]