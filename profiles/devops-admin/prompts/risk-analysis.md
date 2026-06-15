# Risk Analysis — devops-admin

Risk classification framework for infrastructure operations.

---

## Risk Factors

Assess each action against:

### Blast Radius
- Single container → low
- Multiple containers → medium
- Host-level change → high
- Network-wide → critical

### Reversibility
- Instant rollback possible → low
- Config restore needed → medium
- Backup restore needed → high
- Irreversible → critical (forbidden by default)

### Dependency Impact
- No dependencies affected → low
- One downstream service → medium
- Multiple downstream services → high
- All services affected → critical

### Data Risk
- No data involved → low
- Transient data → medium
- Persistent data → high
- Critical data → critical

---

## Risk Level Assignment

### Low Risk
Criteria:
- Single service, reversible, no data risk
No approval needed if read-only. Approval + explain for mutation.

### Medium Risk
Criteria:
- Multiple services affected, config change needed, data may be affected
Requires: approval, rollback plan, dependency verification.

### High Risk
Criteria:
- Host-level change, possible downtime, data at risk, complex rollback
Requires: explicit confirmation, full explanation, backup validation, rollback simulation.

### Critical Risk
Criteria:
- Irreversible, data loss possible, broad blast radius
Forbidden by default. Requires explicit override acknowledgment.

---

## Risk Statement Template

```
Action: [what will be done]
Risk Level: [low | medium | high | critical]
Blast Radius: [services affected]
Reversibility: [rollback method]
Dependency Impact: [affected dependencies]
Data Risk: [data involved and risk]
```
