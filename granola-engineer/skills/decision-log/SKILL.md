---
name: decision-log
description: Extract technical/architectural decisions from Granola meetings and record them as ADR-style entries (context, decision, consequences, alternatives). Use when the user wants a decision log, ADRs, or "what did we decide and why" from meetings.
---

# Decision Log (ADRs) from Granola

Capture the decisions a team made in meetings in a durable, reviewable form.

## When to use

The user asks for a "decision log", "ADRs", "what did we decide", or wants to
record architectural choices from a discussion.

## Steps

1. Find decisions: `query_granola_meetings` with "list the technical decisions
   made and the reasoning", or `get_meetings` on specific IDs. Use
   `get_meeting_transcript` to confirm exact wording of a contested decision.
2. For each decision, extract:
   - **Context** — the problem/forces that prompted it.
   - **Decision** — what was chosen (state it as decided only if the notes say so).
   - **Consequences** — trade-offs, follow-on work, and risks.
   - **Alternatives** — options considered and why they were rejected.
   - **Status** — `accepted`, or `proposed` if not finalized.
3. Write one ADR entry per decision using the template. Number sequentially.
4. Distinguish decided vs. proposed. If the meeting only leaned a direction,
   mark it `proposed` and list the open question.

## ADR template

```markdown
# ADR <n>: <short title>

- Status: accepted | proposed
- Date: <meeting date>
- Source: [[0]](url)

## Context
...

## Decision
...

## Consequences
...

## Alternatives considered
- Option — why not
```

## Guardrails

- Never upgrade a "we're leaning toward X" into an accepted decision.
- Preserve the meeting citation on every ADR for traceability.
- Attribute reasoning to the discussion, not to your own judgment.
