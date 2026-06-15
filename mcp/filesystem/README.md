# MCP: Filesystem

## Purpose

Filesystem read and write operations for Hermes Workspace.

## Scope

- File reading and inspection
- Directory listing and navigation
- File creation and modification (approval-gated)
- File deletion (approval-gated)

## Access Boundaries

| Profile      | Read          | Write                   | Forbidden           |
|-------------|---------------|-------------------------|---------------------|
| default     | /apps/**      | ~/.hermes/profiles/**   | /apps/repos/** (mut)|
| devops-admin| /apps/**, /etc/** | /apps/hermes-agent/**, /apps/9router/** | chmod 777 |
| dev-coder   | /apps/repos/**| /apps/repos/**          | system dirs         |

## Integration

```
MCP Server: filesystem
Transport: stdio or HTTP
Root: / (scoped by profile permissions)
```

## Security

- Path traversal must be prevented at MCP level
- Write operations must check profile permissions
- All writes logged for audit trail
- Destructive operations require additional confirmation
