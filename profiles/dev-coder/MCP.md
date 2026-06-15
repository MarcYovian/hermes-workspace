# MCP — dev-coder (Software Engineer)

## Current MCP Scope (v1)

| MCP          | Access Level | Purpose                                    |
|-------------|-------------|--------------------------------------------|
| filesystem  | read-write  | read/write repository files                |
| git         | read-write  | branch, add, commit, log, diff, status     |
| terminal    | read-only   | run tests, lint, build, debug              |
| docker      | read-only   | inspect compose files, env configs         |
| telegram    | full        | communication gateway                      |

## Integration Notes

- filesystem: full read-write within /apps/repos/*. Destructive operations require approval.
- git: local operations permitted. Push requires approval.
- terminal: test/lint/build commands allowed. System administration commands filtered.
- docker: read-only for development context. No container management.
- telegram: primary communication channel for approval and reporting.

## Access Restrictions

- No access to /apps/hermes-agent/*
- No access to /apps/9router/*
- No access to /etc/, /system/, /var/ outside repos
- All git push operations gated by approval
- Destructive file operations (mass rename, delete) require approval

## Future Roadmap

| MCP          | Phase | Purpose                          |
|-------------|-------|----------------------------------|
| github      | v1.1  | PR creation, issue management    |
| n8n         | v4    | workflow automation              |
| supabase    | v4    | structured storage               |
| postgres    | v4    | database queries                 |

## MCP Philosophy

- minimal integrations, purpose-driven
- each MCP follows least-privilege access
- approval-aware: push operations gated
- no MCP explosion — add only when clearly needed
