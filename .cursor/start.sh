#!/usr/bin/env bash
# Per-boot startup for Cloud Agents. Runs the Docker daemon in the FOREGROUND so
# the platform keeps it supervised for the lifetime of the agent (backgrounding
# and returning is not reliable — the orphaned daemon can be reaped once this
# command exits).
set -euo pipefail

# node-exporter bind-mounts "/" with rslave propagation, which requires the host
# root to be a shared/slave mount.
sudo mount --make-rshared / 2>/dev/null || true

sudo mkdir -p /var/log

# If a daemon is somehow already up, don't launch a second one; stay attached so
# this start command keeps running.
if sudo docker info >/dev/null 2>&1; then
  echo "dockerd already running"
  exec sleep infinity
fi

echo "starting dockerd (fuse-overlayfs)"
exec sudo dockerd --storage-driver=fuse-overlayfs
