# Customizing sandboxes




Docker Sandboxes offers two ways to customize a sandbox beyond the built-in
defaults:

- [Templates](/ai/sandboxes/customize/templates/) — reusable sandbox images with tools, packages,
  and configuration baked in. Extend a base image with a Dockerfile, or
  save a running sandbox as a template.
- [Kits](/ai/sandboxes/customize/kits/) — declarative YAML artifacts that extend an agent with
  tools, credentials, network rules, and files at runtime, or define a new
  agent from scratch.

Kits are experimental. The kit file format, CLI commands, and experience for
creating, loading, and managing kits are subject to change as the feature
evolves. Share feedback and bug reports in the
[docker/sbx-releases](https://github.com/docker/sbx-releases) repository.

## When to use which

| Goal                                                      | Option                                                        |
| --------------------------------------------------------- | ------------------------------------------------------------- |
| Pre-install tools and packages into a reusable base image | [Template](/ai/sandboxes/customize/templates/)                                      |
| Capture a configured running sandbox for reuse            | [Saved template](/ai/sandboxes/customize/templates/#saving-a-sandbox-as-a-template) |
| Add a tool, credential, or config to agent runs via YAML  | [Kit (mixin)](/ai/sandboxes/customize/kits/)                                        |
| Define a new agent from scratch                           | [Kit (agent)](/ai/sandboxes/customize/kits/#defining-an-agent)                      |

Templates and kits can be used together. A template bakes heavy tools into
the image for fast sandbox startup; a kit layered on top adds per-run
credentials, config, or extra capabilities.

## Tutorials

- [Build your own agent kit](/ai/sandboxes/customize/build-an-agent/) — step-by-step walkthrough
  for packaging [Amp](https://ampcode.com/) as an agent kit.

