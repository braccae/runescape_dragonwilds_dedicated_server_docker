# RuneScape: Dragonwilds — Dedicated Server (Docker)

Containerised dedicated server for **RuneScape: Dragonwilds** (Steam App ID `4019830`), based on `cm2network/steamcmd`.

Pulls the server via SteamCMD at build time — no manual install needed.

---

## Quick Start

```bash
podman run -d \
  --name rsdragonwilds \
  --restart unless-stopped \
  -e OwnerId="<your-eos-id>" \
  -e ServerName="My Dragonwilds Server" \
  -e DefaultWorldName="MyWorld" \
  -e WorldPassword="changeme" \
  -e AdminPassword="admin123" \
  -v ./rsdragonwilds-saves:/home/steam/rs_server/RSDragonwilds/Saved/SaveGames \
  -p 7777:7777/udp \
  ghcr.io/<your-org>/runescape_dragonwilds_dedicated_server_docker
```

---

## Configuration

All settings are passed as environment variables. These are substituted at runtime into `DedicatedServer.ini`.

| Variable           | Required | Description                                     |
|--------------------|----------|-------------------------------------------------|
| `OwnerId`          | **Yes**  | EOS ID of the server owner.                     |
| `ServerName`       | No       | Display name of the server in the browser list. |
| `DefaultWorldName` | No       | Name of the default world save.                 |
| `WorldPassword`    | No       | Password to join the world (empty = unprotected). |
| `AdminPassword`    | No       | Password for the server admin screen.            |

> **Where do I find my EOS ID?** Launch the game, go to **Multiplayer → Host Dedicated Server**. Your EOS ID is shown at the bottom of the screen.

---

## Ports

| Port | Protocol | Purpose          |
|------|----------|------------------|
| 7777 | UDP      | Game traffic     |

---

## Volumes

| Container path | Purpose             |
|----------------|---------------------|
| `/home/steam/rs_server/RSDragonwilds/Saved/SaveGames` | World save data |

Mount a volume to persist your world between container restarts.

---

## Podman Quadlet (systemd integration)

A Quadlet file is included in the repo for running the server as a systemd service.

### Install

```bash
cp rsdragonwilds.container rsdragonwilds.volume \
  ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user start rsdragonwilds.service
```

Enable auto-start on boot:

```bash
systemctl --user enable rsdragonwilds.service
sudo loginctl enable-linger $USER   # keep user services alive without login
```

### View logs

```bash
journalctl --user -u rsdragonwilds.service -f
```

---

## Building from source

```bash
podman build -t rsdragonwilds .
```

Or with BuildKit caching:

```bash
DOCKER_BUILDKIT=1 docker build -t rsdragonwilds .
```

---

## GitHub Container Registry

This repo includes a CI workflow (`/.github/workflows/build-and-push.yml`) that automatically builds and publishes the image to `ghcr.io` on every push to `main`.

Pull the latest image:

```bash
podman pull ghcr.io/<your-org>/runescape_dragonwilds_dedicated_server_docker:latest
```

---

## License

See the [LICENSE](LICENSE) file (if present).