---
description: Pull engineering action items and owners from a meeting or recent meetings
---

Follow the `action-items-to-tasks` skill.

1. Determine scope from `$ARGUMENTS`:
   - If it names a meeting/topic, find it with `query_granola_meetings` or
     `list_meetings` and get IDs.
   - If empty, default to `list_meetings` with `time_range: this_week` and
     involvement `captured_by_me: true` / `listed_as_participant: true`.

2. Read content with `get_meetings` on the relevant IDs (or
   `query_granola_meetings` "list all engineering action items and owners").

3. Extract each item as Task / Owner (`unassigned` if unstated) / Due (`none`
   if unstated) / Source (with the citation link). Deduplicate and split
   compound items.

4. Present as a table:

   ```text
   **Action items — <scope>**

   | # | Task | Owner | Due | Source |
   | - | ---- | ----- | --- | ------ |
   ```

5. Offer to create issues/PRs for the items (one logical change per PR) if the
   user wants, using whatever tracker/tooling is available. Never invent owners
   or due dates.
