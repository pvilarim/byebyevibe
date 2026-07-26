#!/usr/bin/env bash
# Bootstrap SDD — ver doc/sistema-sdd-pedro.md v1.1 §12.6
set -euo pipefail
REPO="${1:-.}"
cd "$REPO"

echo "==> OpenSpec..."
npm install -g @fission-ai/openspec@latest
openspec init --tools "cursor,claude" "$REPO" 2>/dev/null || openspec init --tools "cursor,claude"

echo "==> GitNexus (opcional — não aborta o bootstrap se falhar)..."
if npm install -g gitnexus; then
  gitnexus setup || echo "WARN: 'gitnexus setup' falhou — a continuar"
  gitnexus analyze || echo "WARN: 'gitnexus analyze' falhou — a continuar"
else
  echo "WARN: instalação do GitNexus falhou (ex.: binário nativo do onnxruntime bloqueado pela rede) — a continuar sem GitNexus"
fi

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
  # Profile: detect HYBRID when both package.json and openspec/ coexist; warn and default to APP
  if [[ -f "$REPO/package.json" ]] && [[ -d "$REPO/openspec" ]]; then
    echo "WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID." >&2
    echo "      Confirmar: relançar com --profile HYBRID ou DOCS_SPECS se não for APP." >&2
    echo "      A continuar com --profile APP por defeito (passar 'APP', 'DOCS_SPECS' ou 'HYBRID' como 1º argumento)." >&2
    PROFILE="APP"
  elif [[ -f "$REPO/package.json" ]]; then
    PROFILE="APP"
  else
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
