# SkitzoClaw: Claude Code Agent Kit

Welcome to SkitzoClaw, a Docker sandbox kit that provides Claude Code with specialized subagents for different domains of work. This document explains how automatic agent routing works and how to leverage the 7 available agents.

## Overview

SkitzoClaw deploys a **Claude Code session in plan mode** within an isolated Docker sandbox. You have access to 7 specialized subagents, each with a specific domain:

- **heavy-coder** (Opus) — Non-trivial application/library code, complex debugging, multi-file refactors
- **quick-helper** (Haiku) — Lightweight read-only tasks, documentation, summaries, searches
- **reviewer** (Opus) — Code/IaC/config reviews; validates correctness, security, idempotency
- **infra-agent** (Sonnet) — Infrastructure as Code (CDK, CloudFormation, Terraform, Ansible IaC)
- **automation-agent** (Sonnet) — Bash/Python scripts, cron jobs, systemd timers, Ansible playbooks
- **ops-agent** (Sonnet) — Live system diagnosis, log analysis, incident triage (read-only)
- **config-agent** (Sonnet) — Configuring running systems (systemd, networking, packages, dotfiles)

## Automatic Agent Routing (PROACTIVE)

**Key principle:** The main session (Claude Haiku) automatically analyzes your request and routes to the appropriate agent based on task type. You don't need to explicitly invoke agents for common scenarios — the system decides based on what you're trying to accomplish.

### When to Route to Each Agent

#### 1. Heavy-Coder (Opus) — Application Code Implementation
**Automatic triggers:**
- Writing non-trivial application or library code (Python, Go, TypeScript, etc.)
- Complex debugging and troubleshooting of application-level bugs
- Multi-file refactors and architecture decisions
- Implementing new features or fixing bugs in app logic

**Example requests:**
- "Fix the authentication bug in the login flow"
- "Refactor the data processing pipeline to handle 10M+ rows"
- "Debug why this async task isn't completing"

**After heavy-coder completes:** Always route to `reviewer` for validation.

---

#### 2. Quick-Helper (Haiku) — Lightweight Read-Only Tasks
**Automatic triggers:**
- Documentation lookups and API reference searches
- Summaries of existing code or concepts
- Q&A about how things work
- Code search and file inspection
- Man page lookups and CLI help

**Example requests:**
- "Show me the signature of the User model's save method"
- "What dependencies does this package have?"
- "Find all places where we cache responses"
- "Look up the boto3 S3 API documentation"

**When editing is needed:** Quick-helper will hand off to the appropriate domain agent (heavy-coder, infra-agent, etc.) if your request requires mutations.

---

#### 3. Reviewer (Opus) — Code/IaC/Config Validation
**Automatic triggers (always used after mutations):**
- After code changes → validates correctness, security, performance, style
- After IaC changes → validates resource configuration, cost, security
- After config changes → validates idempotency, backup state, rollback safety
- After automation scripts → validates error handling, logging, edge cases

**Example:** After heavy-coder writes code, you'll see the reviewer validate it before marking complete.

**Never skipped:** Always route to reviewer after any file mutation to catch issues early.

---

#### 4. Infra-Agent (Sonnet) — Infrastructure as Code
**Automatic triggers:**
- Designing or modifying AWS infrastructure (CDK, CloudFormation)
- Writing Terraform modules and stacks
- Docker Compose stacks and orchestration
- Ansible provisioning roles (infrastructure provisioning, not live config)
- Infrastructure refactoring and cost optimization

**Example requests:**
- "Create a CDK stack for a multi-region RDS setup"
- "Update the CloudFormation template to add encryption at rest"
- "Write a Terraform module for our VPC"
- "Set up a Docker Compose stack for the dev environment"

**Dry-run discipline:** Infra-agent always validates with `cdk diff`, `terraform plan`, or `cloudformation validate` before applying changes.

**After infra-agent completes:** Route to `reviewer` for security and cost review.

---

#### 5. Automation-Agent (Sonnet) — Scripts, Cron, Systemd, Ansible
**Automatic triggers:**
- Writing Bash or Python automation scripts
- Creating cron jobs, systemd timers, or scheduled tasks
- Authoring Ansible playbooks and roles (for automation/orchestration)
- Building glue code and CI/CD scripts
- Infrastructure automation (provisioning, deployment, scaling)

**Example requests:**
- "Write a script to back up the database daily"
- "Create an Ansible playbook to deploy the app"
- "Set up a systemd timer to run cleanup every hour"
- "Write a Python script to sync data from the API"

**Important:** Automation-agent produces artifacts (scripts, playbooks) but **does not execute them against production**. Execution is handed off to the user or other agents.

**After automation-agent completes:** Route to `reviewer` for security and correctness review.

---

#### 6. Ops-Agent (Sonnet) — Live System Diagnosis (Read-Only)
**Automatic triggers:**
- Diagnosing failures in running systems
- Analyzing logs and error messages
- Inspecting network state, resources, processes
- Investigating performance issues or bottlenecks
- Incident triage and root cause analysis

**Example requests:**
- "The API is responding slowly. Help me diagnose why."
- "The container keeps restarting. Check the logs."
- "Why is this job not completing? Analyze the state."
- "The database is using too much memory. Investigate."

**Read-only discipline:** Ops-agent only observes and reports findings. It hands off actual fixes to:
- `config-agent` if the fix is live system configuration
- `automation-agent` if the fix is automation/scaling logic
- `heavy-coder` if the fix is application code

---

#### 7. Config-Agent (Sonnet) — Live System Configuration
**Automatic triggers:**
- Editing systemd unit files and service configuration
- Modifying networking settings (routing, DNS, firewall)
- Installing/updating packages on running systems
- Editing dotfiles and shell configuration
- Managing secrets and environment variables on live hosts
- Configuring tools like Opnsense, Unraid, or other appliances

**Example requests:**
- "Configure nginx to use HTTPS"
- "Set up a new systemd service for the worker"
- "Install and configure PostgreSQL"
- "Update the kernel parameters for database optimization"

**Backup discipline:** Config-agent always backs up before mutating and can safely roll back if needed.

**Not for IaC:** Use `infra-agent` for declarative infrastructure (CDK, Terraform). Config-agent is for imperative changes to running systems.

---

## Decision Tree: Which Agent to Use?

```
┌─ Is this a read-only lookup or search?
│  ├─ YES → quick-helper (docs, Q&A, code search)
│  │        If editing needed → hand off to domain agent
│  │
│  └─ NO
│
├─ Is this application code (Python/Go/TypeScript)?
│  ├─ YES → heavy-coder
│  │        Then → reviewer for validation
│  │
│  └─ NO
│
├─ Is this infrastructure as code (CDK/Terraform/CloudFormation)?
│  ├─ YES → infra-agent (with dry-run validation)
│  │        Then → reviewer for validation
│  │
│  └─ NO
│
├─ Is this automation (Bash/Python/Ansible scripts, cron, systemd)?
│  ├─ YES → automation-agent
│  │        Then → reviewer for validation
│  │
│  └─ NO
│
├─ Is this diagnosing a failing running system?
│  ├─ YES → ops-agent (read-only diagnosis)
│  │        Then → config-agent or other for fixes
│  │
│  └─ NO
│
└─ Is this configuring a running system?
   ├─ YES → config-agent (with backup discipline)
   │        Then → reviewer for validation
   │
   └─ NO → Use heavy-coder or hand off to appropriate agent
```

## Explicit Agent Invocation

If you need to override automatic routing or invoke a specific agent directly:

**Syntax:** `@agent-<name>`

**Examples:**
```
@agent-heavy-coder Please refactor this function
@agent-infra-agent Write a CDK stack for Lambda functions
@agent-reviewer Review this change for security issues
```

**Browse all agents:**
```
/agents
```

This lists all available agents, their descriptions, tools, and models.

---

## Sandbox Constraints & Limits

This session runs in a Docker sandbox with the following characteristics:

### Plan Mode
- **Effect:** You cannot make mutations (edit files, run destructive commands) without approval
- **Workflow:** You review proposed changes and approve them before they're applied
- **Purpose:** Safety and auditability for infrastructure and system changes

### Network Restrictions
- **Inbound:** Allowed from host (for port publishing)
- **Outbound:** Only Anthropic API (for Claude SDK calls); all other traffic blocked
- **Publishing ports:** Use `sbx ports <sandbox-name> --publish <port>:<port>` on the host to expose services

### Gitignore Guard
- **Effect:** Files listed in `.gitignore` cannot be accessed (read or write)
- **Purpose:** Prevent accidental exposure of secrets, local config, or build artifacts
- **Workaround:** If you need access, update `.gitignore` first

### RTK Compression
- **Effect:** Long command output is automatically compressed to fit context
- **Tool:** `/usr/local/bin/rtk-rewrite-claude.sh`
- **Purpose:** Reduce token usage while keeping relevant output visible

### Workspace
- **Location:** Same absolute path as host (no sync overhead)
- **Access:** Direct file access to project files
- **Git:** Works transparently (credentials injected via sandbox proxy)

---

## Integration with Subagents

### How Routing Works

1. **Task analysis** — Main session (Haiku) analyzes your request
2. **Domain matching** — Determines which agent's scope matches best
3. **Automatic invocation** — Routes to appropriate agent (unless you override with `@agent-name`)
4. **Agent execution** — Agent completes work within its domain
5. **Handoff (if needed)** — For mutations, routes to `reviewer` for validation
6. **Report** — Agent reports findings and completion status

### Agent Boundaries

Each agent has **clear domain boundaries** to prevent cross-domain work:

- **Heavy-coder** — Application code only (not infra, config, automation)
- **Infra-agent** — Declarative IaC only (not live system changes)
- **Automation-agent** — Artifact creation only (not live execution)
- **Config-agent** — Live systems only (not declarative IaC)
- **Ops-agent** — Diagnosis only (not mutations)
- **Quick-helper** — Read-only tasks only (hands off for editing)

If a request spans multiple domains, agents hand off to each other rather than crossing boundaries.

### Approval Workflow

Since this kit runs in plan mode:

1. Agent proposes a change (shows diff or plan)
2. You review the proposed change
3. You approve or request modifications
4. Change is applied

This ensures safety for infrastructure, configuration, and code changes.

---

## Example Scenarios

### Scenario 1: Bug in Application Code
```
You: "The user authentication is broken. Fix it."
→ heavy-coder (analyzes code, identifies bug, writes fix)
→ reviewer (validates correctness, security)
→ You approve → Change applied
```

### Scenario 2: Infrastructure Setup
```
You: "Set up a CDK stack for a Lambda function that processes S3 events"
→ infra-agent (designs stack, writes CDK code, runs cdk diff)
→ reviewer (validates resources, cost, security)
→ You approve → cdk deploy
```

### Scenario 3: System Diagnosis
```
You: "The API is down. Debug it."
→ ops-agent (checks logs, processes, resources)
→ ops-agent reports findings (e.g., "connection pool exhausted")
→ You decide next step → Hand off to config-agent or automation-agent
```

### Scenario 4: Documentation Lookup
```
You: "What's the boto3 API for listing S3 buckets?"
→ quick-helper (searches docs, provides answer)
→ If you then ask "Write a script to list all buckets"
  → automation-agent (creates script)
  → reviewer (validates)
```

---

## Tips for Best Results

1. **Be specific about domain** — "Fix the bug in the auth flow" is clearer than "Something's broken"
2. **Use explicit `@agent-name` if unsure** — Router will use it, avoiding misroutes
3. **Trust the agents** — Each has deep knowledge of their domain
4. **Review changes carefully** — Plan mode means you approve before mutations
5. **Read agent descriptions** — Use `/agents` to see full agent docs with tools and constraints
6. **Hand off gracefully** — Let agents route work to each other (e.g., ops-agent → config-agent)

---

## Quick Reference

| Agent | Model | Domain | Triggers |
|-------|-------|--------|----------|
| heavy-coder | Opus | Application code, debugging | Non-trivial code work |
| quick-helper | Haiku | Read-only tasks | Docs, Q&A, search |
| reviewer | Opus | Code/IaC/config review | After any mutations |
| infra-agent | Sonnet | Infrastructure as Code | CDK, CloudFormation, Terraform |
| automation-agent | Sonnet | Scripts, Ansible, cron | Bash/Python scripts, playbooks |
| ops-agent | Sonnet | Live system diagnosis | Running system issues (read-only) |
| config-agent | Sonnet | Live system config | Editing running systems |

---

## Getting Help

- `/help` — Claude Code help
- `/agents` — Browse all available agents
- Look at individual agent docs — `/agents` shows links to full agent capability files
- Read the kit README — `/Users/honkinwaffles/Documents/projects/DockerSBX/skitzoclaw/README.md`

---

**Last updated:** 2026-05-04  
**Kit:** SkitzoClaw  
**Session mode:** Plan mode (approval required for mutations)
