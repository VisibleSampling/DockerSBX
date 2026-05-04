# DockerSBX kits

Personal kits for [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) — declarative artifacts that extend `sbx run` agents with additional capabilities.

Each top-level directory is a kit containing a `spec.yaml` and a `README.md`.

## Kits

| Kit | Kind | Description |
| --- | --- | --- |
| [`skitzoclaw/`](./skitzoclaw/) | agent | Claude Code on Haiku with plan mode, tightened network policy, gitignore guard, and model-tiered subagents |
| [`skitzodex/`](./skitzodex/) | agent | Codex with tightened network policy, OpenAI service auth, and gitignore guard hooks |
| [`hw-rtk-claude/`](./hw-rtk-claude/) | mixin | Installs RTK and registers a Claude Code Bash rewrite hook for command-output compression |
| [`hw-systemstools/`](./hw-systemstools/) | mixin | Installs Ansible, AWS CLI v2, CDK CLI, boto3, cfn-lint, and systems tooling |

## Using a kit

Pass `--kit` to `sbx run` (or `sbx create`). The flag accepts a local path or a `git+...` URL with a `dir=` fragment.

```console
# Local path
sbx run --kit ./skitzoclaw/ skitzoclaw
sbx run --kit ./skitzodex/ skitzodex

# From this repo
sbx run --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" skitzoclaw
sbx run --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzodex" skitzodex

# Stack mixins on top of the Claude agent kit
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-rtk-claude" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools" \
  skitzoclaw

# Stack mixins on top of the Codex agent kit
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzodex" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools" \
  skitzodex
```

See each kit's `README.md` for kit-specific details.
