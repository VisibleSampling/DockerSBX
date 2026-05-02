# DockerSBX kits

Personal kits for [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) — declarative artifacts that extend `sbx run` agents with additional capabilities.

Each top-level directory is a kit containing a `spec.yaml` and a `README.md`.

## Kits

| Kit | Kind | Description |
| --- | --- | --- |
| [`skitzoclaw/`](./skitzoclaw/) | agent | Claude Code in plan mode with tightened network policy and managed gitignore guard |
| [`hw-rtk-claude/`](./hw-rtk-claude/) | mixin | Installs RTK and registers a Claude Code Bash rewrite hook for command-output compression |
| [`hw-systemstools-claude/`](./hw-systemstools-claude/) | mixin | Installs Ansible, and build tooling |

## Using a kit

Pass `--kit` to `sbx run` (or `sbx create`). The flag accepts a local path or a `git+...` URL with a `dir=` fragment.

```console
# Local path
sbx run --kit ./skitzoclaw/ skitzoclaw

# From this repo
sbx run --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" skitzoclaw

# Stack a mixin on top of the agent kit
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-rtk-claude" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools-claude" \
  skitzoclaw
```

See each kit's `README.md` for kit-specific details.
