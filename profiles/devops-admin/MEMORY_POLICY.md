# MEMORY_POLICY — devops-admin (Infrastructure Specialist)

## Strategy

Mostly Stateless + Active Host Interaction.
Infrastructure state is always read live, not from memory.

## Source of Truth Hierarchy

1. Live filesystem and system state — docker ps, systemctl, ss, journalctl
2. Git repository — configuration files, compose manifests
3. Small persistent memory — stable preferences, conventions

## What to Persist

- known infrastructure service dependencies (e.g., hermes-agent depends on 9router)
- docker compose conventions (e.g., network names, volume mounts)
- rollback patterns for common operations
- stable user preferences for infrastructure
- known backup locations and methods

## What NOT to Persist

- container health status (always check live)
- resource usage metrics (always check live)
- port bindings or network state (always check live)
- transient error states
- temporary debugging output
- service running state

## Memory Scope

~/.hermes/profiles/devops-admin/

## Policy

- memory is for preferences and conventions only
- all operational decisions based on live system state
- never assume service health from memory
- if memory contradicts live state, trust live state
- verify everything, every time
