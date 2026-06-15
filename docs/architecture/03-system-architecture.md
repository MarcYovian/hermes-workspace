# High-Level System Architecture

## Runtime Topology

```txt
Telegram
    │
    ▼
Hermes Gateway (default profile)
    │
    ▼
9Router Model Routing
    │
    ├── devops-admin
    ├── dev-coder
    └── future profiles
```

---

## Infrastructure Layout

```txt
VPS Ubuntu
│
├── /apps/
│   ├── 9router/
│   ├── hermes-agent/
│   └── repos/
│
├── Hermes Agent (Docker)
│   ├── Telegram Gateway
│   ├── Profile System
│   ├── Local Terminal Backend
│   ├── Persistent Memory
│   └── Approval System
│
└── 9Router
    └── LLM Routing Layer
```

---

## Architectural Principles

### P1 — Delegation Over Monolith

Workspace menggunakan:

```txt
multiple specialists
```

bukan:

```txt
1 super-agent
```

---

### P2 — Read Heavy, Write Carefully

Default behavior:

```txt
observe
inspect
explain
recommend
```

Write action:

```txt
explicit approval
```

---

### P3 — Git is Source of Truth

Workspace state penting harus hidup di Git.

Bukan memory agent.

---

### P4 — Human-in-the-loop

Final decision tetap di user.

Hermes bertugas:

```txt
propose
analyze
recommend
assist
```

---

# Workspace Repository Structure

## Repository Name

```txt
hermes-workspace
```

## VPS Location

```txt
/apps/repos/hermes-workspace
```

---

## Repository Structure

```txt
hermes-workspace/
│
├── README.md
├── PRD.md
├── ARCHITECTURE.md
├── CONTRIBUTING.md
├── ROADMAP.md
├── .gitignore
├── .env.example
│
├── docs/
│   ├── architecture/
│
├── profiles/
│   │
│   ├── specs/
│   │   ├── default.md
│   │   ├── devops-admin.md
│   │   └── dev-coder.md
│   │
│   ├── default/
│   │   ├── profile.yaml
│   │   ├── SOUL.md
│   │   ├── SYSTEM_PROMPT.md
│   │   ├── RULES.md
│   │   ├── MEMORY_POLICY.md
│   │   ├── SKILLS.md
│   │   ├── MCP.md
│   │   │
│   │   ├── prompts/
│   │   │   ├── delegation.md
│   │   │   └── safety.md
│   │   │
│   │   └── tests/
│   │       └── delegation-tests.md
│   │
│   ├── devops-admin/
│   │   ├── profile.yaml
│   │   ├── SOUL.md
│   │   ├── SYSTEM_PROMPT.md
│   │   ├── RULES.md
│   │   ├── MEMORY_POLICY.md
│   │   ├── SKILLS.md
│   │   ├── MCP.md
│   │   │
│   │   ├── prompts/
│   │   │   ├── rollback-thinking.md
│   │   │   ├── risk-analysis.md
│   │   │   └── infra-safety.md
│   │   │
│   │   └── tests/
│   │       ├── docker-health.md
│   │       └── troubleshooting.md
│   │
│   └── dev-coder/
│       ├── profile.yaml
│       ├── SOUL.md
│       ├── SYSTEM_PROMPT.md
│       ├── RULES.md
│       ├── MEMORY_POLICY.md
│       ├── SKILLS.md
│       ├── MCP.md
│       │
│       ├── prompts/
│       │   ├── branch-policy.md
│       │   ├── commit-policy.md
│       │   ├── code-review.md
│       │   └── safe-refactoring.md
│       │
│       └── tests/
│           ├── git-workflow.md
│           └── coding-tests.md
│
├── shared/
│   │
│   ├── policies/
│   │   ├── approval-matrix.yaml
│   │   ├── filesystem-boundaries.yaml
│   │   ├── git-governance.yaml
│   │   └── security-policy.yaml
│   │
│   ├── prompts/
│   │   ├── approval-request.md
│   │   ├── escalation.md
│   │   └── troubleshooting.md
│   │
│   ├── context/
│   │   ├── naming-conventions.md
│   │   ├── repo-standards.md
│   │   └── workspace-conventions.md
│   │
│   └── guardrails/
│       ├── forbidden-commands.yaml
│       ├── dangerous-patterns.yaml
│       └── approval-required.yaml
│
├── mcp/
│   ├── docker/
│   ├── filesystem/
│   ├── git/
│   ├── terminal/
│   └── telegram/
│
├── deployment/
│   ├── bootstrap/
│   │   ├── setup-hermes.sh
│   │   ├── sync-profiles.sh
│   │   └── validate-workspace.sh
│   │
│   └── docker/
│       └── docker-compose.example.yml
│
├── decisions/
│   ├── ADR-001-telegram-gateway.md
│   ├── ADR-002-read-heavy-policy.md
│   └── ADR-003-no-main-push.md
│
├── runbooks/
│   ├── hermes-not-responding.md
│   ├── permission-denied.md
│   ├── docker-network-issue.md
│   └── 9router-unhealthy.md
│
└── approvals/
```
