#!/usr/bin/env bash
# Per-boot startup for Cloud Agents: bring up the Docker daemon.
# Idempotent — safe to run again if the daemon is already up.
set -euo pipefail

# node-exporter bind-mounts "/" with rslave propagation; that requires the
# host root to be a shared/slave mount.
sudo mount --make-rshared / 2>/dev/null || true

if ! sudo docker info >/dev/null 2>&1; then
  sudo mkdir -p /var/log
  sudo bash -c 'nohup dockerd --storage-driver=fuse-overlayfs >/var/log/dockerd.log 2>&1 &'
  for _ in $(seq 1 30); do
    if sudo docker info >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done
fi

if sudo docker info >/dev/null 2>&1; then
  echo "dockerd is ready"
else
  echo "dockerd failed to start; see /var/log/dockerd.log" >&2
  exit 1
fi
