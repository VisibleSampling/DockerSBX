# HW Dev Tools

Mixin kit that installs Ansible, and build tooling.

## Use

```console
sbx run claude --kit ./hw-devtools/
```

With SkitzoClaw:

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-devtools" \
  skitzoclaw
```

## Tools installed

- Ansible + ansible-lint
- Python 3, pip
- build-essential

