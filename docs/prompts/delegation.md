# Delegation Prompt — default (Orchestrator)

Use when delegating tasks to specialist profiles.

## Template

```
Task: [brief description of the problem]

Context:
- Repository: [path if applicable]
- Risk Level: [low / medium / high]
- Dependencies: [any cross-domain concerns]

Expected Output:
- [specific deliverable from specialist]

Constraints:
- [scope boundaries]
- [approval requirements]
- [rollback expectations]
```

## Examples

### To aegis

```
Task: Investigate why Hermes Telegram bot is not responding.

Context:
- Risk Level: medium
- Dependencies: none

Expected Output:
- Container health status
- Gateway logs analysis
- Connectivity diagnosis

Constraints:
- Read-only diagnosis first
- No service restart without approval
```

### To forge

```
Task: Fix DataTables rowspan rendering issue.

Context:
- Repository: /apps/repos/project-x
- Risk Level: low
- Dependencies: frontend rendering module

Expected Output:
- Root cause analysis
- Minimal fix implementation
- Validation results

Constraints:
- Create feature branch first
- No main/master modification
- Request approval before push
```
