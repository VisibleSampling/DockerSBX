# HW Systems Tools Claude

Mixin kit that installs Ansible, and build tooling.

## Use

```console
sbx run claude --kit ./hw-systemstools-claude/
```

With SkitzoClaw:

```console
sbx run \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=skitzoclaw" \
  --kit "git+https://github.com/VisibleSampling/DockerSBX.git#dir=hw-systemstools-claude" \
  skitzoclaw
```

## Tools installed

- Ansible + ansible-lint + yamllint
- Python 3, pip, boto3
- AWS CLI v2
- Node.js + npm + AWS CDK CLI (`cdk`)
- cfn-lint
- jq
- build-essential

