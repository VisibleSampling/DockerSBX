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
- Blocks agent from reading files listed in .gitignore (e.g. .env)

## How to 

- Install [DockerSBX](https://docs.docker.com/ai/sandboxes/)
- Navigate to project directory
- Run `sbx run --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-skitzoclaw-core" hw-skitzoclaw-core`
- Login to Claude using sso or API key

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

## Tools installed at build time

- Ansible + ansible-lint
- Python 3, pip, uv
- build-essential
- vim

## Config

Everything is in `hw-skitzoclaw-core/spec.yaml`.
