# Optional, portable bundle of the compose stacks. Building/publishing this
# image is gated (workflow_dispatch or version tags) — see
# .github/workflows/publish.yml. Run it against a mounted Docker socket, e.g.:
#
#   docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
#     -w /stacks/monitoring-analytics \
#     ghcr.io/donny-devops/docker-compose-stacks:latest compose up -d
#
FROM docker:27-cli

LABEL org.opencontainers.image.title="docker-compose-stacks" \
      org.opencontainers.image.description="Portable bundle of the homelab and monitoring compose stacks" \
      org.opencontainers.image.source="https://github.com/donny-devops/docker-compose-stacks" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /stacks

COPY homelab-dashboard/ ./homelab-dashboard/
COPY monitoring-analytics/ ./monitoring-analytics/
COPY README.md ./

ENTRYPOINT ["docker"]
CMD ["compose", "version"]
