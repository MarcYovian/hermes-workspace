---
name: summarization
description: Aggregate specialist outputs into concise executive summaries with findings, recommendations, and risk assessment.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [communication, summarization, reporting, aggregation]
    category: communication
    requires_toolsets: [read]
---

# Result Summarization

Receive outputs from specialist profiles, verify logical consistency, remove irrelevant noise, and present a structured response to the user.

## When to Use

- After receiving results from a delegated specialist task
- After multi-delegation (multiple specialists worked in parallel)
- When user requests a summary of findings
- When consolidating information across domains

## Procedure

1. Collect all specialist outputs for the current task
2. Verify logical consistency across outputs — flag contradictions
3. Remove irrelevant debugging noise and verbose logs
4. Preserve important findings, data points, and recommendations
5. Apply the standard response format (see below)
6. Present the structured response to the user

### Output Format

```
Problem: [what was asked]
Analysis: [findings from specialists]
Recommendation: [proposed action]
Risk: [risk level and considerations]
Next Step: [what happens next]
```

## Pitfalls

- Parroting specialist output without cross-checking for contradictions
- Including internal debugging or verbose specialist logs in the summary
- Omitting risk assessment or making it vague
- Presenting raw specialist output without synthesizing

## Verification

- Confirm all delegated tasks have returned results before summarizing
- Cross-check outputs for logical consistency
- Verify the summary addresses the original user request
- Ensure risk level is explicitly stated, not implied
