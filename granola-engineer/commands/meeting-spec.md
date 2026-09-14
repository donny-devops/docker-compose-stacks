---
description: Turn a design/planning meeting into an engineering spec or implementation plan
---

Follow the `meeting-to-spec` skill.

1. Identify the meeting from `$ARGUMENTS` (title, topic, or "the last design
   meeting"). Use `query_granola_meetings` or `list_meetings` to locate it and
   get the meeting ID(s).

2. Read the content: `get_meetings` for the summary and notes, and
   `get_meeting_transcript` when you need exact requirements or constraints.

3. Draft the spec with this structure, keeping the source citation at the top:
   Problem, Goals, Non-goals, Proposed approach (with alternatives), Risks &
   mitigations, Rollout/milestones, Open questions.

4. Mark anything the meeting did not settle as an **Open question**. Separate
   "decided" from "proposed" — do not invent requirements or acceptance criteria.

5. Ask where to save it (e.g. `docs/`), and offer to open a PR adding the spec.
