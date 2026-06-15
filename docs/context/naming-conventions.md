# Naming Conventions — Shared

Workspace-wide naming standards.

---

## Branch Naming

| Type      | Pattern                  | Example                          |
|-----------|--------------------------|----------------------------------|
| Feature   | feature/<kebab-case>     | feature/select2-server-side      |
| Bug fix   | fix/<kebab-case>         | fix/datatable-rowspan            |
| Docs      | docs/<kebab-case>        | docs/payment-module              |
| Refactor  | refactor/<kebab-case>    | refactor/repository-pattern      |
| Hotfix    | hotfix/<kebab-case>      | hotfix/payment-timeout           |

- Always kebab-case
- No spaces
- No mixed case
- Short but descriptive

## Commit Messages

Required format: `type(scope): description`

Types: feat, fix, refactor, docs, test, chore
Scope: module or area affected (optional but preferred)
Description: imperative mood, lowercase, no period, max 72 chars

## Profile Naming

- Profile directories: kebab-case (devops-admin, dev-coder)
- Profile config files: UPPERCASE with underscores (SYSTEM_PROMPT.md, MEMORY_POLICY.md)
- Shared files: kebab-case with extension

## Directory Naming

- All lowercase
- Hyphens for word separation
- No underscores in directory names
- No spaces

## File Naming

- Profile config: UPPERCASE_WITH_UNDERSCORES.md (SOUL.md, RULES.md)
- Prompt files: kebab-case.md (delegation.md, rollback-thinking.md)
- Test files: kebab-case.md (git-workflow.md, delegation-tests.md)
- Shared files: kebab-case.yaml or kebab-case.md
