# Hermes Workspace PRD v1

**Version:** 1.0  
**Status:** Active Draft  
**Owner:** Yann  
**Primary Runtime:** Hermes Agent (Docker)  
**Primary Interface:** Telegram  
**Model Router:** 9Router  
**Deployment Target:** Ubuntu VPS

---

## Overview

Hermes Workspace adalah AI engineering workspace berbasis Hermes Agent yang berjalan di VPS Ubuntu menggunakan Telegram sebagai interface utama dan 9Router sebagai model routing layer.

Workspace ini dirancang untuk menjadi:

> Safe, auditable, delegated, production-minded AI operating workspace.

Fokus v1:

- Safe VPS operations
- AI coding assistant
- Multi-profile orchestration
- Approval-first workflow
- Git-centric architecture
- Human-in-the-loop automation

Out of scope v1:

- Autonomous trading
- Auto deployment
- Direct production mutation
- Autonomous merge to main/master

---

## Core Principles

Workspace mengikuti prinsip berikut:

1. **Delegation over Monolith**  
   Specialist profiles lebih baik daripada satu super-agent.

2. **Read Heavy, Write Carefully**  
   Read otomatis, write harus intentional.

3. **Git as Source of Truth**  
   Memory bukan sumber utama state.

4. **Human-in-the-loop**  
   Final decision tetap pada user.

5. **Least Privilege Access**  
   Profile hanya punya akses minimum yang dibutuhkan.

---

## Profile Overview

| Profile        | Responsibility            |
| -------------- | ------------------------- |
| `default`      | Orchestrator & delegation |
| `devops-admin` | Infrastructure & VPS      |
| `dev-coder`    | Repository development    |

Detailed specifications:

- [Profile Architecture](./docs/architecture/04-profile-architecture.md)
- [SOUL Philosophy](./docs/architecture/11-soul-philosophy.md)

---

## Architecture Documents

### Foundation

- [Executive Summary](./docs/architecture/01-executive-summary.md)
- [Vision & Goals](./docs/architecture/02-vision-goals.md)
- [System Architecture](./docs/architecture/03-system-architecture.md)
- [Profile Architecture](./docs/architecture/04-profile-architecture.md)
- [Delegation Model](./docs/architecture/05-delegation-model.md)

### Governance & Security

- [Approval Model](./docs/architecture/06-approval-model.md)
- [Security Boundaries](./docs/architecture/07-security-boundaries.md)
- [Filesystem Policy](./docs/architecture/08-filesystem-policy.md)
- [Git Governance](./docs/architecture/09-git-governance.md)

### Agent Design

- [Memory Strategy](./docs/architecture/10-memory-strategy.md)
- [SOUL Philosophy](./docs/architecture/11-soul-philosophy.md)
- [Skills Strategy](./docs/architecture/12-skills-strategy.md)
- [MCP Strategy](./docs/architecture/13-mcp-strategy.md)

### Operations

- [Observability](./docs/architecture/14-observability.md)
- [Failure Handling](./docs/architecture/15-failure-handling.md)
- [Telegram Interaction Model](./docs/architecture/16-telegram-interaction-model.md)
- [Deployment Model](./docs/architecture/17-deployment-model.md)
- [VPS Integration](./docs/architecture/18-vps-integration.md)

### Future & Validation

- [Roadmap](./docs/architecture/19-roadmap.md)
- [Risks and Mitigation](./docs/architecture/20-risks-and-mitigation.md)
- [Acceptance Criteria](./docs/architecture/21-acceptance-criteria.md)

---

## Repository Structure

Workspace repository structure:

- [Architecture Repository Layout](./ARCHITECTURE.md)

---

## Related Documents

- [Contributing Guide](./CONTRIBUTING.md)
- [Roadmap](./ROADMAP.md)
