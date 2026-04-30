# Claude Code




Official documentation: [Claude Code](https://code.claude.com/docs)

## Quick start

Launch Claude Code in a sandbox by pointing it at a project directory:

```console
$ sbx run claude ~/my-project
```

The workspace parameter defaults to the current directory, so `sbx run claude`
from inside your project works too. To start Claude with a specific prompt:

```console
$ sbx run claude --name my-sandbox -- "Add error handling to the login function"
```

Everything after `--` is passed directly to Claude Code. You can also pipe in a
prompt from a file with `-- "$(cat prompt.txt)"`.

## Authentication

Claude Code requires either an Anthropic API key or a Claude subscription.

**API key**: Store your key using
[stored secrets](/ai/sandboxes/security/credentials/#stored-secrets):

```console
$ sbx secret set -g anthropic
```

Alternatively, export the `ANTHROPIC_API_KEY` environment variable in your
shell before running the sandbox. See
[Credentials](/ai/sandboxes/security/credentials/) for details on both methods.

**Claude subscription**: If no API key is set, Claude Code prompts you to
authenticate interactively using OAuth. The proxy handles the OAuth flow, so
credentials aren't stored inside the sandbox.

## Configuration

Sandboxes don't pick up user-level configuration from your host, such as
`~/.claude`. Only project-level configuration in the working directory is
available inside the sandbox. See
[Why doesn't the sandbox use my user-level agent configuration?](/ai/sandboxes/faq/#why-doesnt-the-sandbox-use-my-user-level-agent-configuration)
for workarounds.

Any Claude Code CLI options can be passed after the `--` separator:

```console
$ sbx run claude --name my-sandbox -- --continue
```

See the [Claude Code CLI reference](https://code.claude.com/docs/en/cli-reference)
for available options.

## Base image

The sandbox uses `docker/sandbox-templates:claude-code` and launches Claude Code
with `--dangerously-skip-permissions` by default. See
[Templates](/ai/sandboxes/customize/templates/) to build your own image on top of
this base.

