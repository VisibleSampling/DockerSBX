# HW Systems Tools

Mixin kit that installs Ansible, AWS CLI, CDK, and build tooling.

## Use

```console
sbx run claude --kit ./hw-systemstools/
sbx run codex --kit ./hw-systemstools/
```

With SkitzoClaw:

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools" \
  skitzoclaw
```

With SkitzoDex:

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzodex" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools" \
  skitzodex
```

## Tools installed

- Ansible + ansible-lint + yamllint
- Python 3, pip, boto3
- AWS CLI v2
- Node.js + npm + AWS CDK CLI (`cdk`)
- cfn-lint
- jq
- build-essential
