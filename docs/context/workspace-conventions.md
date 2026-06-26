# Workspace Conventions — Shared

Operational conventions for Hermes Workspace.

---

## Communication Conventions

### Telegram as Primary Interface
- Responses concise, clear, actionable, low-noise
- Use structured format for operations
- Avoid long rambling or over-confidence

### Response Format
```
Problem: [what was asked]
Analysis: [findings based on evidence]
Recommendation: [proposed action]
Risk: [risk level]
Next Step: [what happens next / what user should do]
```

## Approval Conventions

- Read: auto allowed
- Write: plan + risk + command + approval
- Delete: plan + risk + rollback + confirmation
- Restart: inspection first, then plan + approval

Always wait for response. Never assume silence = consent.

## Delegation Conventions

- default is entry point for all requests
- Infrastructure → aegis
- Code → forge
- Mixed → multi-delegation with aggregation
- Default must not directly execute specialist work

## Operational Flow

1. Receive request
2. Understand and categorize
3. Plan approach
4. If mutation: present plan, get approval
5. Execute minimal safe action
6. Validate result
7. Report summary

## Logging Conventions

- All mutations should be traceable
- Use runbooks/ for incident procedures
- Use decisions/ for architecture decisions
- Use logs/ for operational activity

## File Organization

- Profile artifacts are in profiles/<name>/
- Shared artifacts are in shared/
- Deployment scripts in deployment/
- MCP configurations in mcp/
- Architecture decisions in decisions/
- Runbooks in runbooks/
