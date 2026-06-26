---
name: testing
description: Run and validate tests, linting, and static analysis for repository changes.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [testing, validation, linting, quality]
    category: validation
    requires_toolsets: [terminal]
---

# Testing

Run and validate tests, linting, and static analysis for repository changes. Report results with evidence, never assumptions.

## When to Use

- Before starting any change — know the baseline test state
- After every change — verify nothing broke
- Before requesting push approval — test results are required
- When investigating CI failures or test regressions

## Procedure

1. Determine the test framework: PHPUnit, Pytest, Playwright, or framework-specific tooling
2. Run existing test suites before making changes to establish baseline
3. Run linting and static analysis where available
4. After changes, run tests again to confirm nothing broke
5. If no test suite exists, explain the limitation — never claim tests pass without evidence
6. Report test results with real output, not summaries

## Pitfalls

- Claiming tests pass without actually running them
- Only running tests after changes, not before (no baseline)
- Ignoring test failures because they seem pre-existing
- Not running linting/static analysis when available

## Verification

- Confirm test framework is correctly identified for the repository
- Verify baseline test results are recorded before changes
- After changes, confirm same tests pass with identical or fewer failures
- Attach actual test output as evidence — never paraphrase
