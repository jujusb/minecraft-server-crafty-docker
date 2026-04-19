# Minecraft Server Stack

This stack provides a self-hosted Minecraft server management platform (Crafty Controller) with optional HTTPS and reverse proxy via Caddy. The setup is managed with Docker Compose and supports both internal and Cloudflare DNS-based TLS.

---

## Contents
- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Environment Variables](#environment-variables)
- [Build & Run Instructions](#build--run-instructions)
- [Caddy Configuration](#caddy-configuration)
- [Docker Compose Services](#docker-compose-services)
- [Notes](#notes)

---

## Overview
- **Crafty Controller**: Web UI for managing Minecraft servers, backups, logs, and more.
- **Caddy**: Handles HTTPS, reverse proxy, and optional Cloudflare DNS-based TLS for admin and Dynmap access.
- **Docker Compose**: Orchestrates containers and networks.

---

## Directory Structure
- `run.sh` – Main entry script to configure and run the stack.
- `docker-compose.yml` – Defines the Crafty service and networks.
- `docker-compose.root-caddy.yml` – Defines the Caddy service and volumes.
- `.env.example` – Example environment variables for configuration.
- `.gitignore` – Files and directories to ignore in git.
- `caddy_global/Caddyfile` – Caddy reverse proxy configuration.
- `caddy_global/Dockerfile` – Dockerfile for building Caddy with Cloudflare DNS plugin.
- `docker/` – Default data directory for Minecraft servers, backups, logs, etc.

---

## Environment Variables
Copy `.env.example` to `.env` and adjust as needed:

- `MULTIPLE_CADDY_GLOBAL`: Set to `true` for multiple global Caddy services
- `MINECRAFT_SERVER_ADDRESS`: Main Minecraft server address (domain or IP)
- `MINECRAFT_ADMIN_SERVER_ADDRESS`: Domain for Crafty admin web UI
- `MINECRAFT_DYNMAP_SERVER_ADDRESS`: Domain for Dynmap web UI
- `MINECRAFT_DATA_PATH`: Path for persistent Minecraft data (default: `./docker`)
- `TZ`: Timezone (default: UTC)
- `CF_API_TOKEN`: Cloudflare API token for DNS-based TLS
- `HTTP_PORT`, `HTTPS_PORT`: Ports for Caddy (default: 80/443)

---

## Build & Run Instructions

1. Copy and edit environment variables:
   ```sh
   cp .env.example .env
   # Edit .env as needed
   ```
2. Start the stack:
   ```sh
   ./run.sh up -d
   ```
   - The script ensures required Docker networks exist and configures Compose files and TLS based on your environment.
3. To stop the stack:
   ```sh
   ./run.sh down
   ```

---

## Caddy Configuration
- The Caddyfile (`caddy_global/Caddyfile`) sets up reverse proxies for:
  - Crafty admin web UI (HTTPS, with optional TLS verification skip)
  - Dynmap web UI (HTTPS)
- TLS is configured based on whether the server address is an IP (internal TLS) or domain (Cloudflare DNS-based TLS).
- The Caddy Docker image is built with the Cloudflare DNS plugin (see `caddy_global/Dockerfile`).

---

## Docker Compose Services
### docker-compose.yml
- **crafty**: Minecraft server manager
  - Image: `registry.gitlab.com/crafty-controller/crafty-4:4.10.2`
  - Networks: `caddy_net`
  - Volumes: Persistent data for backups, logs, servers, config, import
  - Ports: Minecraft (Bedrock/Java) and management ports

### docker-compose.root-caddy.yml
- **caddy**: Reverse proxy
  - Build context: `./caddy_global`
  - Ports: 80 (HTTP), 443 (HTTPS)
  - Volumes: Caddyfile, data, config
  - Networks: `caddy_net`

---

## Notes
- `.gitignore` excludes `.env` and `caddy_certs`.
- For production, ensure secrets are set securely and not committed to version control.
- For more details, see comments in `run.sh` and the Compose files.

---

## License
See upstream Crafty Controller and Caddy repositories for license details.
