---
name: action-items-to-tasks
description: Extract engineering action items, owners, and commitments from Granola meeting notes and turn them into a clean, deduplicated task list ready to become issues or PRs. Use when the user asks to pull action items / to-dos / follow-ups from meetings and track them as engineering work.
---

# Action Items → Engineering Tasks

Convert what was committed to in meetings into actionable, trackable tasks.

## When to use

The user asks to "pull action items", "what do I owe from that meeting",
"turn the standup into tickets", or "track follow-ups from this week" as
engineering work.

## Steps

1. Gather source material (see the `granola-engineering` skill):
   - For a specific meeting: `get_meetings` with the ID(s).
   - For a period: `list_meetings` (scope with involvement/folder), then
     `get_meetings` on the relevant IDs, or `query_granola_meetings` with a
     prompt like "list all engineering action items and owners".
2. Extract each action item with these fields:
   - **Task** — imperative, specific ("Add retry/backoff to the ingest worker").
   - **Owner** — the named person if stated; otherwise `unassigned`.
   - **Due** — only if explicitly mentioned; otherwise `none`.
   - **Source** — the meeting title/date and citation link.
3. Normalize and deduplicate: merge items that restate the same work; split
   compound items ("fix X and document Y") into separate tasks.
4. Add lightweight acceptance criteria where the notes imply a definition of
   done. Do not invent scope the meeting didn't mention.
5. Present as a table, then offer to create issues/PRs.

## Output format

```text
**Action items — <scope> (<date range>)**

| # | Task | Owner | Due | Source |
| - | ---- | ----- | --- | ------ |
| 1 | ...  | ...   | ... | [[0]](url) |
```

## Creating the work (only when asked)

- Prefer the repo's own tracker. If a GitHub MCP/tooling is available, open one
  issue per task with the source citation in the body; group related items.
- For code changes, create a short task list first and confirm scope before
  editing. Keep one logical change per PR.

## Guardrails

- Never fabricate owners or due dates — leave them `unassigned`/`none`.
- Keep the citation for every task so the user can trace it to the meeting.
- If no action items exist in scope, say so plainly.
