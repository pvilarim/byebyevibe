#!/usr/bin/env bash
# Bootstrap SDD — ver doc/sistema-sdd-pedro.md v1.1 §12.6
set -euo pipefail
REPO="${1:-.}"
cd "$REPO"

echo "==> OpenSpec..."
npm install -g @fission-ai/openspec@latest
openspec init --tools "cursor,claude" "$REPO" 2>/dev/null || openspec init --tools "cursor,claude"

echo "==> GitNexus..."
npm install -g gitnexus
gitnexus setup
gitnexus analyze

echo "==> Graphify..."
if ! command -v uv &>/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
uv tool install graphifyy
graphify install
graphify install --platform cursor
graphify hook install
graphify update .

echo ""
echo "Done. Manual steps (required):"
echo "  1. Edit openspec/project.md"
echo "  2. Create AGENTS.md from template 12.2a or 12.2b in sistema-sdd-pedro.md"
echo "  3. Do NOT paste full gitnexus:start blocks into AGENTS.md"
echo "  4. Run checklist section 2.8 in the guide"
echo "  5. Restart IDE; test /opsx:propose"
