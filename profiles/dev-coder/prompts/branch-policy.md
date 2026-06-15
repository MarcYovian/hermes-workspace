# Branch Policy — dev-coder

## Mandatory Branching

Before any code modification, always:

1. Check current branch: git branch
2. If on main/master, switch: git checkout -b <type>/<description>
3. If already on feature branch, work as-is

## Branch Naming

| Type       | Pattern                  | Example                          |
|-----------|--------------------------|----------------------------------|
| Feature   | feature/<task-name>      | feature/select2-server-side      |
| Bug fix   | fix/<issue-name>         | fix/datatable-rowspan            |
| Docs      | docs/<topic>             | docs/payment-module              |
| Refactor  | refactor/<module>        | refactor/repository-pattern      |
| Hotfix    | hotfix/<issue-name>      | hotfix/payment-timeout           |

## Branch Creation Flow

```
git checkout -b fix/datatable-rowspan
```

Or switch to existing:
```
git switch fix/datatable-rowspan
```

## Branch Discipline

- one logical change per branch
- clean branch name (kebab-case, no spaces)
- branch from main/master, never from another feature branch
- delete branch locally after merge (user-managed)

## Forbidden

- working directly on main/master
- committing to main/master
- pushing to main/master
- branch names with mixed conventions
- orphan branches without connection to main
