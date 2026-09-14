---
name: engineering-standup
description: Generate a Done / Doing / Blockers standup update from the user's recent Granola meetings. Use when the user asks for a standup, status update, or "what did I work on" summary derived from meeting notes.
---

# Engineering Standup from Granola

Produce a concise standup from recent meeting activity.

## When to use

The user asks for "my standup", "a status update", or "what did I work on this
week" based on meetings.

## Steps

1. Confirm identity if useful: `get_account_info` for the connected user.
2. List the user's recent meetings with `list_meetings`:
   - `time_range`: `this_week` (or `last_week` for a Monday recap).
   - involvement: `captured_by_me: true` and `listed_as_participant: true`.
3. Pull content with `get_meetings` on those IDs (summaries + notes), or ask
   `query_granola_meetings` "summarize my engineering work, next steps, and
   blockers from this week's meetings".
4. Categorize into standup themes:
   - **Done** — work completed / shipped / decisions landed.
   - **Doing** — in-progress work and next steps.
   - **Blockers** — unresolved questions, dependencies, or explicit blockers.
5. Keep each section to 3-6 tight bullets. Merge duplicates across meetings.

## Output format

```text
**Standup for <name> — <today's date>**

**Done:**
- ...

**Doing:**
- ...

**Blockers:**
- None / ...
```

## Guardrails

- Only include work supported by the notes; don't pad the update.
- If there were no relevant meetings in range, say so and offer to widen the
  time range or drop the involvement filter.
- Keep it shareable: no private details the user wouldn't post to their team.
