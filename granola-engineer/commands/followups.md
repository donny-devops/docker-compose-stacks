---
description: List your open follow-ups and commitments from recent Granola meetings
---

Follow the `granola-engineering` and `action-items-to-tasks` skills.

1. Call `get_account_info` to identify the connected user.

2. Use `query_granola_meetings` with a prompt like: "What follow-ups, todos, and
   commitments do I still owe from my recent meetings, and to whom?" Preserve
   the numbered citation links it returns.

3. If needed, corroborate with `list_meetings` (`time_range: last_30_days`,
   involvement `captured_by_me: true` / `listed_as_participant: true`) and
   `get_meetings` on the relevant IDs.

4. Present open follow-ups grouped by who is waiting on you or by project:

   ```text
   **Open follow-ups — <name>**

   - [ ] <commitment> — for <person/team> — <source [[0]](url)>
   ```

5. Flag anything overdue or ambiguous. Offer to convert them into tasks/issues
   via the `action-items-to-tasks` skill. Do not fabricate commitments that the
   notes don't support.
