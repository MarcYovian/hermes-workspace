# Skill: Git Workflow

Manage git operations safely with branch isolation and conventional commits.

## Behavior

- Create feature/fix/docs/refactor branches from main
- Never work directly on main/master
- Stage related changes: git add <files>
- Commit with conventional format: type(scope): description
- Request approval before push with summary of changes

## Branch Naming

- feature/<kebab-case>, fix/<kebab-case>, docs/<kebab-case>, refactor/<kebab-case>

## Commit Format

- feat(scope): description, fix(scope): description, refactor(scope): description
- docs(scope): description, test(scope): description, chore(scope): description

## Forbidden

- git push -f, git reset --hard, git clean -fd, direct main/master mutation
