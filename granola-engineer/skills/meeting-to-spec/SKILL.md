---
name: meeting-to-spec
description: Turn a technical discussion captured in Granola into a structured engineering spec or implementation plan (problem, goals, non-goals, approach, risks, milestones). Use when the user wants to convert a design/planning meeting into a spec, RFC, or plan document.
---

# Meeting → Engineering Spec

Transform a design or planning conversation into a spec engineers can build from.

## When to use

The user says "write a spec/RFC/plan from that design meeting", "turn our
discussion into an implementation plan", or references a planning meeting and
wants a document.

## Steps

1. Pull the source: `get_meetings` for the AI summary + private notes, and
   `get_meeting_transcript` when you need exact requirements or constraints as
   they were stated. For multi-meeting topics, use `query_granola_meetings`.
2. Extract signal: problem statement, proposed approach(es), constraints,
   decisions, open questions, and any owners/dates.
3. Draft the spec using the template below. Attribute contested points and
   open questions rather than resolving them yourself.
4. Mark anything not covered in the meeting as **Open question** — never invent
   requirements, SLAs, or acceptance criteria the discussion didn't establish.

## Spec template

```markdown
# <Title>

_Source: <meeting title/date> — [[0]](url)_

## Problem
<what and why, in 2-4 sentences>

## Goals
- ...

## Non-goals
- ...

## Proposed approach
<the design as discussed; note alternatives considered>

## Risks & mitigations
- Risk — mitigation

## Rollout / milestones
1. ...

## Open questions
- ...
```

## Guardrails

- Keep the meeting citation(s) at the top so the spec is traceable.
- Separate "decided" from "proposed/uncertain". If the meeting only floated an
  idea, don't present it as settled.
- Prefer the user's/team's own wording for requirements over paraphrase when it
  changes meaning; quote the transcript for precise constraints.
