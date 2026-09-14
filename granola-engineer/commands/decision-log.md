---
description: Extract technical decisions from meetings as ADR-style entries
---

Follow the `decision-log` skill.

1. Scope from `$ARGUMENTS` (a meeting, a project/folder, or a time range).
   Default to `list_meetings` with `time_range: last_30_days` if empty. Use
   `list_meeting_folders` → `folder_id` to scope to one project when named.

2. Find decisions with `query_granola_meetings` ("list the technical decisions
   made and the reasoning") and/or `get_meetings` on specific IDs. Confirm exact
   wording of any contested decision with `get_meeting_transcript`.

3. Write one ADR per decision, numbered sequentially, each with: Status
   (`accepted` or `proposed`), Date, Source citation, Context, Decision,
   Consequences, and Alternatives considered.

4. Mark not-yet-final decisions as `proposed` and list the open question. Never
   upgrade "leaning toward X" into an accepted decision.

5. Offer to save the ADRs (e.g. under `docs/adr/`) and open a PR.
