---
description: Generate a Done / Doing / Blockers standup from your recent Granola meetings
---

Follow the `engineering-standup` skill.

1. Call `get_account_info` to get the connected user's name.

2. Call `list_meetings` with `time_range: this_week` (use `last_week` if
   `$ARGUMENTS` says "last week") and involvement `captured_by_me: true` and
   `listed_as_participant: true`.

3. Call `get_meetings` on the returned meeting IDs to read summaries and notes,
   or use `query_granola_meetings` to summarize your work, next steps, and
   blockers from those meetings.

4. Categorize into **Done**, **Doing**, and **Blockers** (3-6 bullets each),
   merging duplicates across meetings.

5. Present the standup:

   ```text
   **Standup for <name> — <today's date>**

   **Done:**
   - ...

   **Doing:**
   - ...

   **Blockers:**
   - None / ...
   ```

6. If no meetings match, say so and offer to widen the time range or drop the
   involvement filter. Then offer to post it (e.g. to Slack) if such tooling is
   available.
