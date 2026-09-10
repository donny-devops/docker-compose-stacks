#!/usr/bin/env bash
# Idempotent repository bootstrap for Cloud Agents.
# Installs Docker Engine + Compose and the YAML linter used by CI, and seeds
# per-stack .env files. Docker itself is started per-boot by .cursor/start.sh.
set -euo pipefail

# ── Docker Engine + Compose plugin ─────────────────────────────
if ! command -v docker >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    -o Dpkg::Options::=--force-confold \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    fuse-overlayfs iptables
fi

# Nested VMs need the legacy iptables backend for Docker bridge networking.
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy >/dev/null 2>&1 || true
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy >/dev/null 2>&1 || true

# Let the agent user drive Docker without sudo once the group is active.
sudo groupadd -f docker
sudo usermod -aG docker "$(id -un)" || true

# ── CI tooling: yamllint ───────────────────────────────────────
python3 -m pip install --user --quiet --upgrade yamllint

# ── Seed per-stack .env files (never overwrite an existing one) ─
for stack in homelab-dashboard monitoring-analytics; do
  if [ -f "$stack/.env.example" ] && [ ! -f "$stack/.env" ]; then
    cp "$stack/.env.example" "$stack/.env"
    echo "seeded $stack/.env from .env.example"
  fi
done

echo "install.sh complete"
