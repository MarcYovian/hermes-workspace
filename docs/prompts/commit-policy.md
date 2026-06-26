# Commit Policy — forge

## Conventional Commit Standard

Required format:

```
type(scope): description
```

### Types

| Type      | Usage                              |
|-----------|-------------------------------------|
| feat      | new feature implementation          |
| fix       | bug fix                             |
| refactor  | code change without feature/fix     |
| docs      | documentation only                  |
| test      | adding or updating tests            |
| chore     | maintenance, deps, config           |

### Scope (optional but recommended)

The module/area affected, e.g.:
- odoo, frontend, api, payment, datatable, auth

### Description

- imperative mood ("add" not "added" or "adds")
- lowercase after type(scope):
- no period at end
- max 72 characters

## Examples

```
feat(odoo): add invoice OCR extraction
fix(frontend): resolve hydration mismatch
refactor(api): simplify service layer
docs(payment): add API endpoint docs
test(auth): add login validation tests
chore(deps): update composer dependencies
```

## Commit Discipline

### Do
- small atomic commits — one logical change per commit
- logical grouping — related changes together
- clean history — each commit should compile/pass tests

### Don't
- massive unrelated commits — "fix various things"
- mixed concern commits — feat + fix + chore in one commit
- debug commits — "testing something", "wip"
- temporary workaround commits — "temp fix", "hack"

## Commit Flow

```
git add <specific files>
git commit -m "fix(datatable): resolve rowspan rendering"
```

Or for multi-line:
```
git commit -m "feat(api): add export endpoint"
git commit -m "- implement CSV export controller"
git commit -m "- add rate limiting middleware"
```
