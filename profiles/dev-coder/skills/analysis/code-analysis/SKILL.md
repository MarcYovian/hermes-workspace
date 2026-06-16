---
name: code-analysis
description: Inspect and understand repository structure, architecture, and code patterns before making changes.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [analysis, architecture, code-review, conventions]
    category: analysis
    requires_toolsets: [read, terminal]
---

# Code Analysis

Inspect and understand repository structure, architecture, and code patterns before implementing any change.

## When to Use

- Before starting any new feature or fix
- When unfamiliar with a repository's structure
- Before refactoring — understand the current architecture first
- When assessing the scope and impact of a proposed change

## Procedure

1. Inspect repo structure: directory layout, key files, entry points
2. Understand architecture patterns: MVC, Service Layer, Repository Pattern, module conventions
3. Identify dependency impact: what modules or systems will be affected
4. Identify existing conventions: code style, naming, framework patterns
5. Report findings before starting implementation

## Pitfalls

- Starting implementation without understanding the full architecture
- Missing dependency chains that the change will affect
- Assuming framework conventions instead of verifying from the codebase
- Ignoring existing patterns and introducing inconsistent style

## Verification

- Confirm directory structure matches the described architecture
- Verify dependency impact assessment covers all affected modules
- Cross-check findings against actual code, not assumptions
- Ensure report is shared before implementation begins
