# DevOps Automation

This repository ships a layered CI/CD, security, and maintenance automation
setup. Most of it works out of the box on GitHub-hosted runners with the
default `GITHUB_TOKEN`. A few capabilities need repository settings, secrets,
or GitHub Apps that only an administrator can configure. This document lists
what is automatic and what requires action.

## Workflows

| Workflow | Trigger | Purpose | Blocking? |
| --- | --- | --- | --- |
| `ci.yml` | push/PR to `main` | yamllint, `compose config`, compose smoke test, Trivy config scan (SARIF) | lint/validate/smoke: yes; Trivy: no |
| `gitleaks.yml` | push/PR, dispatch | Secret scanning (SARIF) | yes |
| `kics.yml` | push/PR, dispatch | Docker Compose misconfig scan (SARIF) | no |
| `actionlint.yml` | workflow changes | Lint GitHub Actions workflows | yes |
| `codeql.yml` | push/PR, weekly | CodeQL analysis (`actions` language) | no |
| `zizmor.yml` | workflow changes | GitHub Actions security audit (SARIF) | no |
| `image-scan.yml` | compose changes, weekly | Trivy image CVE scan per compose image (SARIF) | no |
| `security-hygiene.yml` | push/PR, dispatch | Hardened-runner audit + secret pattern block | yes |
| `release-please.yml` | push to `main` | Version bumps, `CHANGELOG.md`, tags, GitHub Releases | n/a |
| `pr-title-lint.yml` | PR | Enforce Conventional Commits PR titles | yes |
| `stale.yml` | daily | Triage stale issues/PRs | n/a |
| `gist-summary.yml` | weekly, dispatch | Publish stack inventory to a Gist | n/a (no-op unless configured) |
| `publish.yml` | version tags, dispatch | Build + push a stacks bundle image to GHCR | n/a (gated) |

Dependency bots: `.github/dependabot.yml` (GitHub Actions) and `renovate.json`
(docker-compose image tags + digest pinning). Optional local hooks live in
`.pre-commit-config.yaml`.

## Secrets and variables

All are configured under **Settings → Secrets and variables → Actions**.

| Name | Kind | Required | Used by | Notes |
| --- | --- | --- | --- | --- |
| `GITHUB_TOKEN` | secret | automatic | most workflows, GHCR publish | Provided by GitHub; no action needed. |
| `GIST_TOKEN` | secret | optional | `gist-summary.yml` | PAT with the `gist` scope. Without it the workflow no-ops. |
| `GIST_ID` | variable | optional | `gist-summary.yml` | The target Gist id. Without it the workflow no-ops. |
| `RENOVATE_TOKEN` | secret | optional | self-hosted Renovate only | Only if you run Renovate via a workflow with a PAT instead of the App. |
| `GITLEAKS_LICENSE` | secret | optional | `gitleaks.yml` | Only required for Gitleaks in an **organization** account. |
| release PAT | secret | optional | `release-please.yml` | Only if you want the release PR to re-trigger `on: pull_request` CI (the default `GITHUB_TOKEN` cannot). |

Never commit secret values. The secret-pattern check in `security-hygiene.yml`
and Gitleaks both fail the build on committed credentials.

## GitHub Apps (installed via each app's console; admin required)

- **Renovate** — install the Renovate GitHub App on the repo so `renovate.json`
  is picked up. Alternatively run Renovate self-hosted with `RENOVATE_TOKEN`.
- **Cursor Bugbot** / **Mergify** — optional PR review / merge-queue apps.

## Repository settings (admin)

- **Code scanning / Security tab** — the SARIF uploads (`gitleaks`, `kics`,
  `trivy`, `codeql`, `zizmor`, `image-scan`) populate **Security → Code
  scanning** after they run on `main`.
- **CodeQL default vs advanced** — this repo uses **advanced** setup
  (`codeql.yml`). If **default** CodeQL setup is enabled in
  Settings → Code security, disable it to avoid a conflict (pick one).
- **Actions permissions** — SARIF upload needs `security-events: write`, which
  each relevant job already declares. Ensure workflow token permissions are not
  globally restricted below that.
- **GHCR package visibility** — after the first `publish.yml` run, set the
  package's visibility (public/private) under the package settings.

## Cursor MCP (`.cursor/mcp.json`)

The scaffold enables the `filesystem` and `git` MCP servers (no tokens) and a
`github` server that reads `GITHUB_PERSONAL_ACCESS_TOKEN` from your local
environment (never committed). Add more servers/targets as your team needs.

## External APIs / hosted agents

Any additional external API integrations, hosted agents/subagents, or bots
beyond the above need concrete targets plus their own credentials before they
can be wired in. Add the target endpoint and store its token as an Actions
secret, then reference it from a new workflow.
