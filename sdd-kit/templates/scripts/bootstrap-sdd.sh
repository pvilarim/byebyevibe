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
echo "==> SDD Install Kit (payloads)..."
if [[ -f "$REPO/sdd-kit/install.sh" ]]; then
  # Profile: infer DOCS_SPECS if no package.json app at root
  PROFILE="APP"
  if [[ ! -f "$REPO/package.json" ]] && grep -q 'DOCS_SPECS' "$REPO/openspec/project.md" 2>/dev/null; then
    PROFILE="DOCS_SPECS"
  elif [[ ! -f "$REPO/package.json" ]]; then
    PROFILE="DOCS_SPECS"
  fi
  bash "$REPO/sdd-kit/install.sh" --profile "$PROFILE" --repo "$REPO" || {
    echo "WARN: sdd-kit/install.sh failed — run manually after editing project.md profile"
  }
else
  echo "WARN: sdd-kit/install.sh not found — copy kit from hub or run after add-sdd-install-kit"
fi

echo ""
echo "Done. Manual steps (required):"
echo "  1. Edit openspec/project.md"
echo "  2. Merge AGENTS.md if install.sh kept existing file (templates: sdd-kit/templates/AGENTS.core.md)"
echo "  3. Do NOT paste full gitnexus:start blocks into AGENTS.md"
echo "  4. bash sdd-kit/verify.sh + checklist section 2.8 in the guide"
echo "  5. Restart IDE; test /opsx:propose"
