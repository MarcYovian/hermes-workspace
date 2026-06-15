# Safe Refactoring — dev-coder

Framework for safe, incremental refactoring.

---

## Refactoring Principles

1. **Understand before refactor** — full grasp of current code before touching
2. **Incremental** — one module at a time, not full rewrite
3. **Test-protected** — ensure tests pass before and after
4. **Reversible** — each step should be undoable
5. **Diff-minimal** — change only what needs changing

## Refactoring Decision Matrix

| Scenario                          | Approach                       | Risk   |
|-----------------------------------|--------------------------------|--------|
| Simple rename                     | Direct change                  | Low    |
| Extract method                    | Add new, redirect old          | Low    |
| Move class to new namespace       | Add + deprecate                | Medium |
| Change data structure             | Add new, migrate, remove old   | Medium |
| Replace ORM query with raw SQL    | Avoid unless proven bottleneck | High   |
| Full module rewrite               | Avoid without strong reason    | High   |

## Refactoring Workflow

1. Inspect current code and tests
2. Create backup branch: git checkout -b refactor/<module>-prep
3. Run existing tests to establish baseline
4. Plan changes incrementally
5. For each increment:
   a. Make minimal change
   b. Run tests
   c. Commit: refactor(scope): description
6. Verify final state
7. Present summary for push approval

## Anti-Patterns

- refactoring and feature development in same branch
- changing code style across entire file while refactoring
- "while we're here" scope creep
- premature optimization disguised as refactoring
- rewriting working code to match new patterns

## When NOT to Refactor

- working code with acceptable maintainability
- code about to be replaced anyway
- without test coverage (unless trivial)
- during bug fix — fix first, refactor later
- unless justified by clear improvement
