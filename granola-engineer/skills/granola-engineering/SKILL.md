---
name: granola-engineering
description: Router and reference for using the Granola MCP tools in an engineering workflow. Read this before pulling meeting content to pick the right tool, apply involvement/time filters, respect note-access scopes, and preserve citations. Use whenever a task turns meeting notes into engineering artifacts (tasks, specs, standups, ADRs, follow-ups).
---

# Granola for Engineers

This skill explains how to get the right meeting content out of Granola and feed
it into engineering workflows. The other skills in this plugin (action items,
meeting-to-spec, standup, decision log) build on the tool-selection rules here.

## Tools and when to use each

| Tool | Use it for | Avoid when |
| --- | --- | --- |
| `query_granola_meetings` | Open-ended, natural-language questions across meetings ("what did we decide about auth?"). Returns a synthesized answer with inline citations. | You already have exact meeting IDs, or you need a verbatim transcript. |
| `list_meetings` | Enumerating meetings in a time range (`this_week`, `last_week`, `last_30_days`), optionally filtered by folder or involvement. | You want content synthesis — use `query_granola_meetings`. |
| `get_meetings` | Detailed content (private notes, AI summary, attendees, metadata) for specific meeting IDs (max 10). | You don't yet know which meetings matter — list/query first. |
| `get_meeting_transcript` | Exact quotes / verbatim wording from one meeting. | You only need a summary — `get_meetings` is cheaper. |
| `list_meeting_folders` | Discover folder IDs to scope a search to a project/team. | The user hasn't asked to browse by folder. |
| `get_account_info` | Confirm which account is connected and the note-access scopes. | Not needed for routine content queries. |

## Standard flow

1. If results might be empty or the account matters, call `get_account_info`
   first to confirm identity and `mcp_note_access.scopes`.
2. Discover: `query_granola_meetings` for a question, or `list_meetings`
   (+ `list_meeting_folders`) to enumerate candidates.
3. Drill in: `get_meetings` on the specific IDs; `get_meeting_transcript` only
   when exact wording is required.
4. Transform the content with the appropriate skill (tasks / spec / standup / ADR).

## Filters that matter for engineering

- Scope to "my" meetings by setting both involvement conditions on
  `list_meetings`: `captured_by_me: true` and `listed_as_participant: true`
  (true conditions combine with OR). Set a condition to `false` to exclude.
- Use `time_range` deliberately: standups use `this_week`/`last_week`; audits
  and decision logs often need `last_30_days`.
- Use `list_meeting_folders` → `folder_id` to restrict to a single project.

## Rules

- Preserve citations. `query_granola_meetings` returns numbered citation links
  like `[[0]](url)`. Always carry these through into your output so the user can
  verify claims against the source note.
- Respect scopes. `personal` scope covers the user's own/shared/private-folder
  notes; `public` covers workspace Team Space folders. If a search is empty,
  say so and note it may be a scope/plan limitation rather than inventing data.
- Never fabricate action items, owners, dates, or decisions. If a detail (owner,
  due date) isn't in the notes, mark it as unassigned/unknown rather than guessing.
- Speaker labels in transcripts are approximate: `Me`/`Them` are audio
  fallbacks and `Speaker A/B` are unnamed voices — don't over-attribute quotes.
