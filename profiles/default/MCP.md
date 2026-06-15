# MCP — default (Orchestrator)

## Current MCP Scope (v1)

Profile may use these MCP tools for read-only operations:

| MCP          | Access Level | Purpose                             |
|-------------|-------------|-------------------------------------|
| filesystem  | read-only   | inspect repo structure, configs, logs |
| git         | read-only   | view branch, log, diff, status       |
| docker      | read-only   | docker ps, inspect, logs, stats      |
| terminal    | read-only   | run diagnostics, system inspection   |
| telegram    | full        | primary communication gateway        |

## Integration Notes

- filesystem: scoped to /apps/* (read). Write restricted to ~/.hermes/profiles/default/*
- git: only read operations. No commit, push, merge access.
- docker: only read operations. No compose or container management.
- terminal: diagnostic commands only. Mutation commands filtered by guardrails.

## Future Roadmap

| MCP          | Phase | Purpose                          |
|-------------|-------|----------------------------------|
| github      | v1.1  | PR review, issue management      |
| n8n         | v4    | workflow automation              |
| supabase    | v4    | persistent storage               |
| postgres    | v4    | structured query access          |

## MCP Philosophy

- minimal integrations, purpose-driven
- each MCP follows least-privilege access
- approval-aware: write operations blocked at MCP level
- no MCP explosion — add only when clearly needed
