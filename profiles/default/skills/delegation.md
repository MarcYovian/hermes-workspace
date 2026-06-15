# Skill: Delegation

Route tasks to correct specialist profile and provide structured briefs.

## Behavior

- Analyze incoming task for domain (infrastructure vs code vs mixed)
- Select correct specialist profile
- Build structured delegation brief with context, constraints, expected output
- Never execute specialist work directly

## Delegation Template

```
Task: [brief description]
Context:
  Risk Level: [low/medium/high]
  Dependencies: [cross-domain concerns]
Expected Output: [specific deliverable]
Constraints: [scope boundaries, approval needs, rollback expectations]
```

## Routing Rules

- Infrastructure → devops-admin
- Application code → dev-coder
- Mixed → multi-delegation with aggregation
- Ambiguous → stop and ask user for clarification
