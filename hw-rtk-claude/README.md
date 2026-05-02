# HW RTK Claude

Mixin kit that installs RTK and registers a managed Claude Code Bash rewrite hook for automatic command-output compression.

## Use

```console
sbx run claude --kit ./hw-rtk-claude/
```

With SkitzoClaw from this repository:

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-rtk-claude" \
  skitzoclaw
```

## Verify

```bash
command -v rtk
rtk --version
rtk git status
printf '%s\n' '{"tool_input":{"command":"git status"}}' | /usr/local/bin/rtk-rewrite-claude.sh
```
