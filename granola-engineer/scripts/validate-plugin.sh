#!/usr/bin/env bash
# Validate the granola-engineer plugin structure:
#   - all JSON manifests/configs parse and carry required fields
#   - every skill has YAML frontmatter with `name` and `description`
#   - every command has YAML frontmatter with `description`
set -euo pipefail

cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }
ok() { echo "OK:   $*"; }

check_json() {
  local f="$1"
  if python3 -c "import json,sys; json.load(open('$f'))" 2>/dev/null; then
    ok "JSON parses: $f"
  else
    err "JSON invalid: $f"
  fi
}

# 1. JSON manifests / MCP configs
for f in .cursor-plugin/plugin.json .claude-plugin/plugin.json .mcp.json .cursor-mcp.json; do
  [ -f "$f" ] || { err "missing $f"; continue; }
  check_json "$f"
done

# 2. Required manifest fields
python3 - <<'PY' || fail=1
import json, sys
m = json.load(open(".cursor-plugin/plugin.json"))
missing = [k for k in ("name", "description", "version", "skills") if k not in m]
if missing:
    print(f"FAIL: .cursor-plugin/plugin.json missing {missing}", file=sys.stderr); sys.exit(1)
if m["name"] != "granola-engineer":
    print(f"FAIL: unexpected plugin name {m['name']!r}", file=sys.stderr); sys.exit(1)
print("OK:   plugin.json has name/description/version/skills")
PY

# 3. MCP server declared
python3 - <<'PY' || fail=1
import json, sys
for f in (".mcp.json", ".cursor-mcp.json"):
    d = json.load(open(f))
    if "granola" not in d.get("mcpServers", {}):
        print(f"FAIL: {f} does not declare a 'granola' MCP server", file=sys.stderr); sys.exit(1)
print("OK:   granola MCP server declared in both configs")
PY

# 4. Frontmatter checks
frontmatter_has() {
  # $1 = file, rest = required keys
  local f="$1"; shift
  awk 'NR==1 && $0=="---"{fm=1; next} fm && $0=="---"{exit} fm{print}' "$f"
}

for skill in skills/*/SKILL.md; do
  [ -f "$skill" ] || { err "no skills found"; break; }
  fm="$(frontmatter_has "$skill")"
  echo "$fm" | grep -q '^name:' && echo "$fm" | grep -q '^description:' \
    && ok "skill frontmatter: $skill" \
    || err "skill missing name/description frontmatter: $skill"
done

for cmd in commands/*.md; do
  [ -f "$cmd" ] || { err "no commands found"; break; }
  fm="$(frontmatter_has "$cmd")"
  echo "$fm" | grep -q '^description:' \
    && ok "command frontmatter: $cmd" \
    || err "command missing description frontmatter: $cmd"
done

echo
if [ "$fail" -ne 0 ]; then
  echo "VALIDATION FAILED"; exit 1
fi
echo "VALIDATION PASSED"
