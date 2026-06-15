# MEMORY_POLICY — default (Orchestrator)

## Strategy

Mostly Stateless + Small Persistent Memory.

## Source of Truth Hierarchy

1. Git repository — code, config, docs, architecture
2. Filesystem state — docker configs, logs, project files
3. Small persistent memory — stable preferences only

## What to Persist

- stable user preferences (e.g., preferred response style, approval patterns)
- workspace conventions (e.g., branch naming, commit format)
- project conventions per repo
- recurring workflow patterns
- delegation preferences (e.g., which specialist for which task)

## What NOT to Persist

- raw chat history or conversation logs
- temporary debugging output
- transient error states
- short-lived context (current task details)
- infrastructure state (always inspect live)
- code state (always read from filesystem)

## Memory Scope

All persistent data stored under: ~/.hermes/profiles/default/

## Policy

- memory is auxiliary, not authoritative
- always verify live state before acting
- if memory contradicts filesystem, trust filesystem
- if memory contradicts git, trust git
- clear memory on workspace reconfiguration
