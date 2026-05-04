# HW RTK Claude

Mixin kit that installs RTK and registers a managed Claude Code Bash rewrite hook for automatic command-output compression.

The hook rewrites Bash commands through `rtk rewrite` before Claude runs them. If RTK does not rewrite a command, the hook still wraps it with `rtk run` so Bash usage consistently flows through RTK.

RTK is currently installed from upstream `master`. Pin this mixin to a known tested release or commit once a stable RTK ref is chosen.

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
