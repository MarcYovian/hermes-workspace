---
name: minimal-refactor
description: Refactor code incrementally with minimal diffs and respect for existing architecture.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [refactoring, incremental, clean-code, architecture]
    category: refactoring
    requires_toolsets: [read, terminal]
---

# Minimal Refactoring

Refactor code incrementally with minimal diffs and respect for existing architecture. One module at a time, never a full rewrite.

## When to Use

- Improving readability or maintainability of existing code
- Reducing technical debt in a specific module
- Extracting shared logic from duplicated code
- Preparing code for a new feature that requires cleaner structure

### When NOT to Refactor

- Working code with acceptable maintainability — leave it alone
- Code about to be replaced — don't waste effort
- Without test coverage (unless the change is trivially safe)
- During bug fixes — fix first, refactor later in a separate branch

## Procedure

1. Understand the code fully before touching it
2. Ensure tests pass before starting
3. Refactor one module at a time — never attempt a full rewrite
4. Keep each change step reversible
5. Ensure tests still pass after each change
6. Change only what needs changing — no scope creep

## Pitfalls

- Mixing refactoring with feature work in the same branch
- Mixing style changes with logic changes
- Scope creep ("while we're here" syndrome)
- Premature optimization disguised as refactoring
- Refactoring without test coverage as a safety net

## Verification

- Confirm tests pass before and after each refactoring step
- Verify the diff only contains intentional changes (no unrelated modifications)
- Check that existing behavior is preserved (no logic changes hidden in the refactor)
- Ensure each commit in the branch is a coherent, reviewable unit
