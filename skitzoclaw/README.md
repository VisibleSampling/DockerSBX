# SkitzoClaw

Docker Sandbox (sbx) agent kit for running Claude Code in a restricted environment with increased security and safety.

## Why

Docker Sandbox (sbx) was built to reduce the blast radius of running agents in yolo mode. SkitzoClaw takes that further — tightening network access, enforcing plan mode, and generally limiting what the agent can do or reach.

## What it does

- Launches Claude Code in plan mode
- Restricts network to Anthropic endpoints only
- Injects the Anthropic API key via service auth (automatic SSO is not working and requires login on first start)
- Disables co-authored-by in commits
- Allows the use of MCPs in project files
- Blocks agent from reading files listed in .gitignore (e.g. .env) — deterrent only, not guaranteed; shell access means a determined agent can find bypasses

## Use

- Install [DockerSBX](https://docs.docker.com/ai/sandboxes/)
- Navigate to project directory
- Run `sbx run --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" skitzoclaw`
- Login to Claude using sso or API key

## Optional mixins

The [`hw-rtk-claude`](../hw-rtk-claude/) mixin installs RTK and registers a managed Bash rewrite hook for automatic command-output compression.

The [`hw-systemstools`](../hw-systemstools/) mixin installs Ansible, AWS CLI v2, CDK, boto3, cfn-lint, and build tooling.

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-rtk-claude" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools" \
  skitzoclaw
```

## Subagents

Seven Claude Code subagents are installed at `~/.claude/agents/` and available in every session. Claude defaults to Haiku for orchestration and routes heavier work to the appropriate subagent automatically.

| Agent | Model | Purpose |
| --- | --- | --- |
| `heavy-coder` | Opus | Non-trivial implementation, complex debugging, architecture |
| `quick-helper` | Haiku | Docs, summaries, search, Q&A — read-only |
| `reviewer` | Sonnet | Code review after changes — read-only |
| `infra-agent` | Sonnet | AWS, CDK, Ansible, IaC (requires `hw-systemstools`) |
| `automation-agent` | Sonnet | Scripts, cron jobs, systemd timers, Ansible roles — builds automation artifacts |
| `ops-agent` | Sonnet | Live-system diagnosis, log analysis, incident triage — read-only |
| `config-agent` | Sonnet | Live system configuration — systemd, networking, packages, Opnsense, Unraid |

Invoke explicitly with `@agent-heavy-coder` or browse all agents with `/agents`.

## MCP Servers

MCPs are configured per-project via `.mcp.json` in the project root. Use `uv tool run` (not `uvx`) for Python-based servers.

```json
{
  "mcpServers": {
    "python": {
      "command": "uv",
      "args": ["tool", "run", "python-interpreter-mcp"]
    }
  }
}
```

## Config

Everything is in [`spec.yaml`](./spec.yaml).
