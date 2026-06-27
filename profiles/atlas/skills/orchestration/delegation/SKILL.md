---
name: delegation
description: Route tasks to the correct specialist profile and provide structured delegation briefs.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [orchestration, routing, delegation]
    category: orchestration
    requires_toolsets: [read]
---

# Delegation

Route incoming tasks to the appropriate specialist profile and provide structured briefs that include context, constraints, and expected output.

## When to Use

- Task domain is outside orchestrator scope (infrastructure or code)
- Task requires specialist tools or permissions
- Task is mixed-domain and needs decomposition

## Procedure

1. Analyze the incoming task domain: infrastructure, code, or mixed
2. Select the correct specialist profile based on domain
3. Build a structured delegation brief (see template below)
4. Delegate the full brief to the specialist
5. Never execute specialist work directly — always delegate

### Delegation Template

```
Task: [brief description]
Context:
  Risk Level: [low/medium/high]
  Dependencies: [cross-domain concerns]
Expected Output: [specific deliverable]
Constraints: [scope boundaries, approval needs, rollback expectations]
```

### Routing Rules

- Infrastructure → aegis
- Application code → forge
- Mixed → multi-delegation with aggregation
- Ambiguous → stop and ask for clarification

## Pitfalls

- Delegating without enough context causes rework and confusion
- Executing specialist work directly bypasses safety checks
- Not verifying specialist output before reporting to user
- Delegating ambiguous tasks without first clarifying with user

## Verification

- Confirm specialist profile matches task domain
- Verify delegation brief includes all required sections
- After delegation, confirm the specialist accepted the task
- On return, verify output addresses the original task
