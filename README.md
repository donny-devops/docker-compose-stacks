# Docker Compose Stacks

A collection of **Docker Compose stacks** for quickly bringing up common development, demo, and self-hosted infrastructure setups.

## Overview

This repository organizes multiple `docker-compose` configurations into isolated stacks (folders), each representing a cohesive application or service group (for example: monitoring, logging, databases, or full web apps).[web:47][web:48]  
Each stack is designed to be self-contained, with its own Compose file, environment configuration, and usage instructions.

## Repository Structure

```bash
docker-compose-stacks/
├── README.md
├── stacks/
│   ├── monitoring/
│   │   ├── docker-compose.yml
│   │   └── .env.example
│   ├── logging/
│   │   ├── docker-compose.yml
│   │   └── .env.example
│   ├── postgres/
│   │   ├── docker-compose.yml
│   │   └── .env.example
│   └── ...
└── shared/
    ├── networks/
    └── volumes/
```

> Adjust stack names to match your actual use cases (e.g., `prometheus-grafana`, `elasticsearch-kibana`, `minio`, `redis`).[web:52][web:55]

## Getting Started

### Prerequisites

- Docker Engine and Docker Compose v2 installed[web:53][web:56]
- Basic familiarity with `docker compose up` / `docker compose down`

### Clone the Repository

```bash
git clone https://github.com/your-username/docker-compose-stacks.git
cd docker-compose-stacks
```

### Start a Stack

Navigate into a stack directory and bring it up:

```bash
cd stacks/monitoring
cp .env.example .env  # optional, then edit values
docker compose up -d
```

To stop and remove containers:

```bash
docker compose down
```

If a stack uses named volumes, `docker compose down -v` can be used to remove them when you intentionally want to destroy data.[web:49]

## Stack Conventions

To keep stacks modular, maintainable, and predictable:

- **One concern per stack**: avoid mixing unrelated services into a single stack.[web:48][web:49]
- **Own directory per stack**: each stack has its own `docker-compose.yml` and optional `.env.example`.[web:47][web:52]
- **Named volumes for stateful data**: use named volumes instead of anonymous volumes to ensure persistence and clarity.[web:49]
- **Environment variables**: prefer `.env` files (copied from `.env.example`) for credentials, ports, and configuration.
- **Networks**: define explicit networks where cross-stack communication is needed, or keep stacks isolated by default.
- **Healthchecks**: define `healthcheck` for services that other containers depend on.[web:53]
- **Profiles**: use Compose profiles when you want optional services (e.g., `debug`, `admin`, `demo`).[web:53]

## Example: Monitoring Stack (Prometheus + Grafana)

```bash
stacks/monitoring/
├── docker-compose.yml
└── .env.example
```

`docker-compose.yml` (high level):

- `prometheus` service with config volume
- `grafana` service with data volume
- Shared network `monitoring_net`
- Named volumes `prometheus-data`, `grafana-data`[web:58]

Usage:

```bash
cd stacks/monitoring
cp .env.example .env
docker compose up -d
```

Access:

- Prometheus: http://localhost:${PROMETHEUS_PORT}
- Grafana: http://localhost:${GRAFANA_PORT}

## Environment Files

Each stack can define an `.env.example` file with the most important configuration knobs:

```env
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=changeme
```

Workflow:

1. Copy `.env.example` to `.env`.
2. Adjust values for your environment.
3. Run `docker compose` from the same directory; Compose automatically picks up `.env`.

## Development vs Production

For some stacks it can be useful to maintain separate overrides:

- `docker-compose.yml` — base config
- `docker-compose.override.yml` — local/dev overrides
- `docker-compose.prod.yml` — production-specific changes (e.g., restart policies, resource limits, different ports)[web:56][web:59]

Examples:

```bash
# Local/dev
docker compose up -d

# Production-style run
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Recommended production adjustments include:

- Removing bind-mounts for application code
- Setting `restart: unless-stopped` or `always`
- Adding resource limits and healthchecks
- Using external secrets / config mechanisms[web:53][web:56][web:57]

## Best Practices

- Keep each stack small and purpose-driven; resist 20+ container “monster” stacks.[web:48][web:50]
- Use version control (git) for all Compose files, env examples, and configs.[web:47][web:60]
- Document required ports, credentials, and initial setup steps in per-stack README snippets.
- Prefer official images and follow Dockerfile best practices (multi-stage builds, minimal base images).[web:54]
- Use `docker compose logs -f <service>` and healthchecks to debug startup issues.[web:53]
- Treat stacks as disposable: persistent data lives in volumes or external services, not containers.

## Roadmap

- Add more stacks (databases, message brokers, observability tools, app templates).
- Add Makefiles or helper scripts for common workflows (e.g., `make up`, `make down`, `make logs`).
- Add CI to lint and validate compose files.
- Add optional Traefik / nginx reverse-proxy stack for shared ingress.
- Add documentation per stack, including diagrams and example use cases.

## License

Choose a license that fits your intended use, such as MIT, Apache-2.0, or a private internal license.
