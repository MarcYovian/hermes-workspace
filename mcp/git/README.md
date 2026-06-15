# MCP: Git

## Purpose

Git operations for repository management.

## Scope

- Repository inspection (status, log, diff, branch)
- Branch creation and switching
- File staging (git add)
- Committing (git commit)
- Pushing (approval required)
- Reading repository state

## Access Control

| Operation       | dev-coder      | devops-admin  | default    |
|----------------|----------------|---------------|------------|
| git status     | auto           | auto          | auto       |
| git log        | auto           | auto          | auto       |
| git diff       | auto           | auto          | auto       |
| git branch     | auto           | auto          | auto       |
| git checkout -b| auto           | blocked       | blocked    |
| git add        | auto           | blocked       | blocked    |
| git commit     | auto           | blocked       | blocked    |
| git push       | approval       | blocked       | blocked    |
| git push -f    | forbidden      | forbidden     | forbidden  |

## Branch Protection

- main/master — no direct commit, push, or modification
- All work must be on feature/fix/docs/refactor branches
- Force push forbidden by default

## Integration

```
MCP Server: git
Transport: stdio or HTTP
Root: /apps/repos/
```

## Security

- Push operations gated by approval
- Force push blocked at MCP level
- Protected branch rules enforced
