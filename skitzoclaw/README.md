# SkitzoClaw

Docker Sandbox (sbx) agent kit for running Claude Code in a restricted environment with increased security and safety.

## Why

Docker Sandbox (sbx) was built to reduce the blast radius of running agents in yolo mode. SkitzoClaw takes that further — tightening network access, enforcing plan mode, and generally limiting what the agent can do or reach.

## What it does

- Launches Claude Code in plan mode
- Runs the main Claude Code session as the `skitzoclaw-coordinator` subagent for automatic routing
- Restricts network to Anthropic endpoints only
- Maps Anthropic service auth for API-key injection when a sandbox credentials source is configured; otherwise Claude may still require login or an API key on first start
- Disables co-authored-by in commits
- Allows the use of MCPs in project files
- Best-effort guard blocks common Claude tools (`Read`, `Edit`, `Write`, `Bash`, `Grep`, `Glob`) from accessing files listed in `.gitignore` (e.g. `.env`). This is a deterrent, not a guarantee; shell access and complex paths can have bypasses.

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

Eight Claude Code subagents are installed at `~/.claude/agents/` and available in every session. The main session starts as `skitzoclaw-coordinator` with Haiku, then routes work to the appropriate specialist automatically. This avoids depending on `CLAUDE.md` for routing behavior, because Docker Sandbox can regenerate that file.

| Agent | Model | Purpose |
| --- | --- | --- |
| `skitzoclaw-coordinator` | Haiku | Main-session router; delegates work to the specialist agents |
| `heavy-coder` | Opus | Non-trivial implementation, complex debugging, architecture |
| `quick-helper` | Haiku | Docs, summaries, search, Q&A — read-only |
| `reviewer` | Opus | Code review after changes — read-only |
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
