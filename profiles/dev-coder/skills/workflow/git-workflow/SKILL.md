---
name: git-workflow
description: Manage git operations safely with branch isolation, conventional commits, and push-gated workflow.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [git, workflow, branching, version-control]
    category: workflow
    requires_toolsets: [git]
---

# Git Workflow

Manage git operations safely with branch isolation, conventional commits, and push-gated workflow.

## When to Use

- Starting any new work — always create a branch first
- Committing changes — use conventional commit format
- Before pushing — prepare summary and request approval
- When switching context between tasks

## Procedure

1. Create a feature/fix/docs/refactor branch from main: `git checkout -b <type>/<kebab-case>`
2. Never work directly on main or master
3. Stage related changes: `git add <files>`
4. Commit with conventional format: `type(scope): description`
5. Before push: prepare summary of changes with branch target, risk assessment, and test results
6. Request explicit approval before push

### Branch Naming

- `feature/<kebab-case>`, `fix/<kebab-case>`, `docs/<kebab-case>`, `refactor/<kebab-case>`

### Commit Format

- `feat(scope):`, `fix(scope):`, `refactor(scope):`, `docs(scope):`, `test(scope):`, `chore(scope):`

### Forbidden

- `git push -f`, `git reset --hard`, `git clean -fd`
- Direct commit or push to main/master
- Destructive rebase or history rewrite

## Pitfalls

- Working on main directly because "it's a small change"
- Pushing without approval after making local commits
- Overly large commits that mix concerns
- Force pushing to fix a merge conflict instead of merging properly

## Verification

- Confirm current branch is not main/master before making changes
- Verify commit message follows conventional format
- Confirm push was explicitly approved before executing
- After push, verify remote branch exists and is correct
