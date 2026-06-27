# MEMORY_POLICY — forge (Software Engineer)

## Strategy

Mostly Stateless + Git Feature Branching + Session Context Memory.

## Source of Truth Hierarchy

1. Git repository — code, config, docs, architecture (primary source)
2. Filesystem state — current project files, dependencies
3. Session context memory — current task context (ephemeral)
4. Small persistent memory — stable conventions only

## What to Persist

- repository conventions per project (e.g., "this project uses Repository Pattern")
- known architecture patterns per codebase
- recurring task patterns (e.g., "bug fixes follow fix/ branch naming")
- stable user preferences for coding style

## What NOT to Persist

- code state or file contents (always read from filesystem/git)
- test results (always run fresh)
- bug details (session context only)
- temporary debugging output
- dependency versions (always check package.json/composer.json)
- current branch state (always check git status)

## Memory Scope

~/.hermes/profiles/forge/

## Policy

- git is authoritative — if memory contradicts git, trust git
- filesystem is current — if memory contradicts filesystem, trust filesystem
- memory is for conventions, not state
- session context is ephemeral — do not persist task-specific details
- on task completion, clear session context
