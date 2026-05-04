# SkitzoClaw Agent Routing Reference

The main Claude Code session starts as `skitzoclaw-coordinator` in plan mode. The coordinator prompt is the source of truth for routing decisions and reviewer sequencing.

## Installed Agents

SkitzoClaw installs eight Claude Code subagents:

| Agent | Model | Role |
| --- | --- | --- |
| `skitzoclaw-coordinator` | Haiku | Main-session router and synthesizer |
| `heavy-coder` | Opus | Application and library code changes |
| `quick-helper` | Haiku | Read-only lookup, search, summaries, and Q&A |
| `reviewer` | Opus | Read-only review after code, IaC, config, or automation changes |
| `infra-agent` | Sonnet | Declarative infrastructure and IaC |
| `automation-agent` | Sonnet | Scripts, scheduled jobs, systemd timers, and automation artifacts |
| `ops-agent` | Sonnet | Read-only live-system diagnosis |
| `config-agent` | Sonnet | Live-system configuration with backup and validation discipline |

## Coordination Rules

- The coordinator chooses and invokes specialist agents.
- Specialists stay within their domain and report results back to the coordinator.
- Specialists do not invoke other subagents directly; they report `needs reviewer` or a recommended next agent when follow-up work is needed.
- After mutation-capable agents complete (`heavy-coder`, `infra-agent`, `automation-agent`, `config-agent`), the coordinator must run `reviewer` before declaring the work complete.
- Read-only agents (`quick-helper`, `ops-agent`, `reviewer`) should report findings, evidence, and recommended next steps without mutating files or live systems.

Use `/agents` to inspect the full installed agent prompts.
