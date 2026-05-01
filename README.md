# SandClaw

Docker Sandbox agent kit for running Claude Code in a restricted environment.

## Why

Docker Sandbox (sbx) was built to reduce the blast radius of running agents in yolo mode. SandClaw takes that further — tightening network access, enforcing plan mode, and generally limiting what the agent can do or reach.

## What it does

- Launches Claude Code in plan mode
- Restricts network to Anthropic endpoints only
- Injects the Anthropic API key via service auth
- Disables co-authored-by in commits

## Tools installed at build time

- Ansible + ansible-lint
- Python 3, pip, uv
- build-essential
- vim

## Config

Everything is in `hw-SandClaw/spec.yaml`.
