# MCP — devops-admin (Infrastructure Specialist)

## Current MCP Scope (v1)

| MCP          | Access Level | Purpose                                  |
|-------------|-------------|------------------------------------------|
| filesystem  | read-write  | inspect and modify infra files (approval) |
| docker      | read-write  | container management, compose operations  |
| terminal    | read-write  | system diagnostics, service management    |
| git         | read-only   | view compose and config history           |
| telegram    | full        | communication gateway                     |

## Integration Notes

- filesystem: write restricted to /apps/hermes-agent/* and /apps/9router/*. All writes require approval.
- docker: full access but approval-gated for mutations. Read operations auto-allowed.
- terminal: diagnostic commands auto-allowed. Service management commands approval-gated.
- git: read-only. No application code modification.

## MCP Security

Every MCP integration follows:
- least privilege — minimum access for task
- explicit scope — bounded paths and operations
- approval-aware — write operations require user confirmation
- audit trail — all mutations logged

## Future Roadmap

| MCP          | Phase | Purpose                          |
|-------------|-------|----------------------------------|
| github      | v1.1  | deployment workflow integration  |
| n8n         | v4    | automated runbook execution      |
| supabase    | v4    | infrastructure state storage     |
| postgres    | v4    | database administration          |

No MCP explosion. Add only when clearly needed.
