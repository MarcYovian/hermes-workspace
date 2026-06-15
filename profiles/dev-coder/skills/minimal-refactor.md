# Skill: Minimal Refactoring

Refactor code incrementally with minimal diffs and respect for existing architecture.

## Behavior

- Understand code fully before refactoring
- One module at a time, never full rewrite
- Ensure tests pass before and after
- Each step should be reversible
- Change only what needs changing

## When NOT to Refactor

- Working code with acceptable maintainability
- Code about to be replaced
- Without test coverage (unless trivial)
- During bug fixes (fix first, refactor later)

## Anti-Patterns

- Refactoring + features in same branch
- Style changes mixed with logic changes
- Scope creep ("while we're here")
- Premature optimization disguised as refactoring
