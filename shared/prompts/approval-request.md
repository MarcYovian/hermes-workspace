# Approval Request Template — Shared

Standard approval request format used by all profiles.

---

## Approval Request Format

```
=== Approval Request ===

Action: [one-line description of what will be done]
Profile: [default | devops-admin | dev-coder]
Risk Level: [low | medium | high | critical]

Plan:
1. [step 1]
2. [step 2]
3. [step 3]

Exact Command(s):
```
[exact commands to be executed]
```

Risk Assessment:
- Services affected: [list]
- Downtime: [estimated if any]
- Data risk: [none | backup needed | irreversible]
- Blast radius: [scope of impact]

Rollback Plan:
- [step 1 to undo]
- [step 2 to undo]

Approval: Please confirm to proceed.
=== End ===
```

## Usage Notes

- Read-only actions: no approval needed
- Level 1 (write/edit): use Plan + Risk + Commands format
- Level 2 (delete/high risk): add Rollback Plan + explicit confirmation
- Level 3 (forbidden): do not request approval — explain policy violation
- Always wait for user response before executing
- Never assume silence means consent
