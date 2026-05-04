# SkitzoDex

Docker Sandbox (sbx) agent kit for running Codex in a restricted environment with increased security and safety.

## Why

Docker Sandbox (sbx) reduces the blast radius of running agents. SkitzoDex keeps the Skitzo security posture for Codex: restricted network access, project-local configuration, and a guard that blocks access to files listed in `.gitignore`.

## What it does

- Launches Codex using the Docker Sandbox Codex default entrypoint
- Restricts network to OpenAI/Codex endpoints only
- Injects OpenAI credentials via service auth
- Adds Codex hook configuration under `~/.codex/`
- Blocks agent access to files listed in `.gitignore` (e.g. `.env`) where Codex hook coverage allows it
- Avoids `AGENTS.md` for kit behavior because Docker SBX imports/overwrites it

## Use

- Install [DockerSBX](https://docs.docker.com/ai/sandboxes/)
- Configure OpenAI auth for Docker SBX:

```console
sbx secret set -g openai
```

or:

```console
sbx secret set -g openai --oauth
```

- Navigate to project directory
- Run `sbx run --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzodex" skitzodex`

## Optional mixins

The [`hw-systemstools`](../hw-systemstools/) mixin installs Ansible, AWS CLI v2, CDK, boto3, cfn-lint, and build tooling.

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzodex" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools" \
  skitzodex
```

## Config

Codex-specific files are in [`files/home/.codex/`](./files/home/.codex/). The kit intentionally does not rely on `AGENTS.md`.
