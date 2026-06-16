---
name: safety-check
description: Pre-action safety validation to prevent unauthorized mutations, destructive operations, and scope violations.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [safety, governance, guardrails, validation]
    category: governance
    requires_toolsets: [read]
---

# Safety Check

Validate every action against the orchestrator's operational rules before execution.

## When to Use

- Before any write/mutate action
- Before any destructive or delete action
- Before delegating to a specialist
- When risk level is unclear
- When task objective seems ambiguous

## Procedure

1. Classify the action: read-only, write/mutate, or delete/destructive
2. Check if the action falls within orchestrator scope
3. If read-only: proceed
4. If write/mutate: require user approval
5. If delete/destructive: require approval + explicit confirmation
6. If out of scope: delegate to appropriate specialist
7. If risk level unclear: clarify with user before proceeding

### Forbidden Action Detection

Block and escalate when detecting:
- Infrastructure mutation: apt, ufw, iptables, systemctl, service
- Docker mutation: docker compose up/down, docker restart, docker rm
- Git mutation: git commit, git push, git merge, git checkout main
- Dangerous commands: chmod 777, rm -rf, docker system prune, sudo without approval

### Clarification Triggers

Stop and ask user when:
1. Task objective ambiguous
2. Missing context about architecture or dependencies
3. Risk level unclear or potentially destructive
4. Multiple specialists possibly needed but unclear which
5. User asks for action outside defined scope

## Pitfalls

- Assuming an action is safe without verifying current state first
- Proceeding without approval on write operations
- Not blocking destructive commands early enough
- Skipping verification because action seems routine

## Verification

- Confirm action classification is correct (read vs write vs delete)
- Verify current system state before approving any mutation
- Check delegated actions also pass the safety check
- After action completes, verify system is in expected state

## Appendix A: Approval Matrix

| Action Type     | Approval Required | Confirmation Required |
|-----------------|-------------------|----------------------|
| Read-only       | No                | No                   |
| Write/Mutate    | Yes               | No                   |
| Delete/Destructive | Yes            | Yes                  |
