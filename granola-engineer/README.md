# granola-engineer

A [Cursor](https://cursor.com) and [Claude Code](https://claude.com/claude-code)
plugin that turns [Granola](https://granola.ai) meeting notes into engineering
artifacts. It bundles the Granola MCP server with a set of skills and slash
commands so an AI agent can move from "what we discussed" to tasks, specs,
standups, and decision records.

## What's inside

### MCP server

The plugin registers the **Granola** MCP server (`.mcp.json` for Claude Code,
`.cursor-mcp.json` for Cursor), which exposes:

- `query_granola_meetings` — natural-language Q&A across meetings (with citations)
- `list_meetings` / `list_meeting_folders` — enumerate meetings and folders
- `get_meetings` — detailed notes, summaries, attendees for specific IDs
- `get_meeting_transcript` — verbatim transcript for exact quotes
- `get_account_info` — connected account and note-access scopes

### Skills

| Skill | Purpose |
| --- | --- |
| `granola-engineering` | Router/reference: which tool to use, filters, scopes, citation rules. Read first. |
| `action-items-to-tasks` | Extract action items/owners and turn them into a deduped task list (ready for issues/PRs). |
| `meeting-to-spec` | Convert a design/planning meeting into a structured spec/RFC. |
| `engineering-standup` | Build a Done/Doing/Blockers standup from recent meetings. |
| `decision-log` | Record technical decisions as ADR-style entries. |

### Commands

| Command | Description |
| --- | --- |
| `/standup` | Standup from your recent meetings. |
| `/action-items` | Pull action items and owners from a meeting or recent meetings. |
| `/meeting-spec` | Turn a meeting into an engineering spec. |
| `/decision-log` | Extract technical decisions as ADRs. |
| `/followups` | List open follow-ups and commitments you owe. |

## Installation

Copy the `granola-engineer/` directory into your plugin marketplace/source, or
point your client at this folder. On first use you'll authenticate to Granola
via the MCP server's OAuth flow, then the skills and commands become available.

- **Cursor** reads `.cursor-plugin/plugin.json` and `.cursor-mcp.json`.
- **Claude Code** reads `.claude-plugin/plugin.json` and `.mcp.json`.

## Usage examples

```text
/standup last week
/action-items the payments design sync
/meeting-spec ingest pipeline redesign
/decision-log #platform this month
/followups
```

Or just ask naturally: "From my Granola notes, what did we decide about auth,
and what do I still owe the team?"

## Configuration notes

- The bundled MCP config points at Granola's remote MCP endpoint
  (`https://mcp.granola.ai/mcp`). Verify it against Granola's current MCP
  documentation and update the URL/auth if Granola changes it.
- Results reflect your Granola plan and note-access scopes (`personal` vs
  `public`). If a query returns nothing, it may be a scope/plan limitation, not
  an empty history — run `get_account_info` to check.

## Guardrails

Every skill is built to avoid fabrication: unstated owners are `unassigned`,
unstated dates are `none`, "leaning toward X" is never recorded as a final
decision, and meeting citations are preserved so any claim can be traced back to
the source note.

## License

MIT — see [LICENSE](LICENSE).
