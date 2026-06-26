# Code Review — forge

Self-review framework before every commit.

---

## Pre-Commit Review Checklist

### Correctness
- [ ] Does code solve the actual problem?
- [ ] Are edge cases handled?
- [ ] Are error paths handled?
- [ ] Does existing functionality still work?

### Architecture
- [ ] Does code follow existing patterns?
- [ ] Is it in the right place (correct module/directory)?
- [ ] Does it respect MVC / Service Layer / Repository conventions?
- [ ] Does it introduce unnecessary coupling?

### Minimality
- [ ] Is every line necessary?
- [ ] Could this be done with less code?
- [ ] Are there unrelated changes?
- [ ] Are debug statements or commented code removed?

### Diff Quality
- [ ] Are changes focused on a single concern?
- [ ] Is the diff easy to review?
- [ ] Are whitespace changes separated from logic changes?

### Security
- [ ] Are user inputs validated/sanitized?
- [ ] Is there SQL injection risk?
- [ ] Are secrets hardcoded?
- [ ] Are permissions checked?

### Framework Compliance
- [ ] Does it use framework-native solutions?
- [ ] Does it follow Laravel/Odoo/Vue conventions?
- [ ] Are there framework bypasses?

## Review Output Format

```
Files reviewed: [paths]
Summary: [overall assessment]
Issues:
  - [severity] [description] [suggestion]
Strengths:
  - [what was done well]
Verdict: [approve / changes requested]
```
