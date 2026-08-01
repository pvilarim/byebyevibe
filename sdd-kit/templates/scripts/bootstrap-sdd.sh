#!/usr/bin/env bash
# Bootstrap SDD — see doc/sistema-sdd-pedro.md §2 / §12.6
# C1 order: OpenSpec → GitNexus → Graphify → sdd-kit/install.sh (MUST NOT change)
set -euo pipefail

QUIET=false
SKIP_PREFLIGHT=false
CHAT_LANG="${SDD_CHAT_LANG:-en}"
REPO="."
PROFILE_FLAG=""
POSITIONAL=()

usage() {
  cat <<'EOF'
Usage: bootstrap-sdd.sh [REPO_PATH] [--quiet|-q] [--chat-lang en|pt-BR] [--profile APP|DOCS_SPECS|HYBRID] [--skip-preflight]

Bootstraps OpenSpec, GitNexus, Graphify, then sdd-kit/install.sh.
Didactic S-layer banners print only on a TTY when --quiet is unset.
Non-TTY (CI) omits banners even without --quiet. WARN/ERROR always print.

Options:
  --quiet, -q         Suppress didactic banners (keep WARN/ERROR + phase markers)
  --chat-lang LANG    Banner language: en (default) or pt-BR (also SDD_CHAT_LANG)
  --profile PROFILE   Skip auto-detection: APP, DOCS_SPECS, or HYBRID (passed to install.sh)
  --skip-preflight    Skip phase-0 preflight (legacy/CI escape hatch)
  -h, --help          Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q) QUIET=true; shift ;;
    --skip-preflight) SKIP_PREFLIGHT=true; shift ;;
    --profile)
      PROFILE_FLAG="${2:-}"
      case "$PROFILE_FLAG" in
        APP|DOCS_SPECS|HYBRID) ;;
        *) echo "ERROR: --profile must be APP, DOCS_SPECS, or HYBRID (got '${PROFILE_FLAG:-}')" >&2; usage 2 ;;
      esac
      shift 2
      ;;
    --chat-lang)
      CHAT_LANG="${2:-}"
      [[ -n "$CHAT_LANG" ]] || { echo "ERROR: --chat-lang requires a value" >&2; usage 2; }
      shift 2
      ;;
    -h|--help) usage 0 ;;
    --) shift; POSITIONAL+=("$@"); break ;;
    -*)
      echo "ERROR: unknown option: $1" >&2
      usage 2
      ;;
    *) POSITIONAL+=("$1"); shift ;;
  esac
done

if [[ ${#POSITIONAL[@]} -gt 0 ]]; then
  REPO="${POSITIONAL[0]}"
fi
if [[ ${#POSITIONAL[@]} -gt 1 ]]; then
  echo "ERROR: unexpected arguments: ${POSITIONAL[*]:1}" >&2
  usage 2
fi

case "$CHAT_LANG" in
  en|pt-BR) ;;
  *)
    echo "WARN: unsupported --chat-lang '$CHAT_LANG' — falling back to en" >&2
    CHAT_LANG="en"
    ;;
esac

cd "$REPO"
REPO="$(pwd)"

# Profile hint MUST be snapshotted before `openspec init` creates openspec/ (D1)
PRE_INIT_HAD_OPENSPEC=false
[[ -d "$REPO/openspec" ]] && PRE_INIT_HAD_OPENSPEC=true

# Phase 0 — Preflight (full --all) before OpenSpec unless --skip-preflight
if ! $SKIP_PREFLIGHT; then
  PREFLIGHT_SCRIPT=""
  if [[ -f "$REPO/scripts/preflight-sdd.sh" ]]; then
    PREFLIGHT_SCRIPT="$REPO/scripts/preflight-sdd.sh"
  elif [[ -f "$REPO/sdd-kit/templates/scripts/preflight-sdd.sh" ]]; then
    PREFLIGHT_SCRIPT="$REPO/sdd-kit/templates/scripts/preflight-sdd.sh"
  fi
  if [[ -z "$PREFLIGHT_SCRIPT" ]]; then
    echo "ERROR: preflight-sdd.sh not found (tried scripts/ and sdd-kit/templates/scripts/)." >&2
    echo "       Copy kit from hub, or pass --skip-preflight to bypass phase 0." >&2
    exit 1
  fi
  echo "==> Phase 0 — Preflight ($PREFLIGHT_SCRIPT --all)..."
  bash "$PREFLIGHT_SCRIPT" --all --repo-root "$REPO" || {
    echo "ERROR: preflight FAILED — aborting bootstrap before OpenSpec install." >&2
    echo "       Fix FAIL items, or re-run with --skip-preflight." >&2
    exit 1
  }
else
  echo "==> Phase 0 — Preflight skipped (--skip-preflight)"
fi

# Didactic banners: TTY only, and not when --quiet (D6)
SHOW_BANNERS=false
if [[ -t 1 ]] && ! $QUIET; then
  SHOW_BANNERS=true
fi

banner() {
  local tool="$1"
  $SHOW_BANNERS || return 0
  echo ""
  if [[ "$CHAT_LANG" == "pt-BR" ]]; then
    case "$tool" in
      openspec)
        echo "--- OpenSpec ---"
        echo "O que: O roteiro da mudança: pensar → combinar → fazer → guardar o registro"
        echo "Sem ela, conversa vira código e ninguém lembra o porquê"
        ;;
      gitnexus)
        echo "--- GitNexus ---"
        echo "O que: O mapa do código do seu repo"
        echo "Sem ela, a IA mexe no feeling e quebra o lado"
        ;;
      graphify)
        echo "--- Graphify ---"
        echo "O que: O mapa do que o time já sabe (docs, decisões, ideias)"
        echo "Sem ela, a IA reinventa o que o time já escreveu"
        ;;
      kit)
        echo "--- sdd-kit ---"
        echo "O que: A caixa de ferramentas que liga tudo isso no seu projeto"
        echo "Sem ela, cada repo monta o processo do zero"
        ;;
    esac
  else
    case "$tool" in
      openspec)
        echo "--- OpenSpec ---"
        echo "What: The playbook for a change: think → agree → do → keep a record"
        echo "Without it, chat turns into code and nobody remembers why"
        ;;
      gitnexus)
        echo "--- GitNexus ---"
        echo "What: The map of your repo's code"
        echo "Without it, the AI edits by vibe and breaks the neighborhood"
        ;;
      graphify)
        echo "--- Graphify ---"
        echo "What: The map of what the team already knows (docs, decisions, ideas)"
        echo "Without it, the AI reinvents what the team already wrote"
        ;;
      kit)
        echo "--- sdd-kit ---"
        echo "What: The toolbox that wires the control plane into this repo"
        echo "Without it, every repo invents the process from scratch"
        ;;
    esac
  fi
  echo ""
}

banner openspec
echo "==> OpenSpec..."
npm install -g @fission-ai/openspec@latest
openspec init --tools "cursor,claude" "$REPO" 2>/dev/null || openspec init --tools "cursor,claude"

banner gitnexus
echo "==> GitNexus (optional — does not abort bootstrap on failure)..."
if npm install -g gitnexus; then
  gitnexus setup || echo "WARN: 'gitnexus setup' failed — continuing"
  gitnexus analyze || echo "WARN: 'gitnexus analyze' failed — continuing"
else
  echo "WARN: GitNexus install failed (e.g. onnxruntime native binary blocked by network) — continuing without GitNexus"
fi

banner graphify
echo "==> Graphify (optional — does not abort bootstrap on failure)..."
graphify_phase() {
  if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh || return 1
    export PATH="$HOME/.local/bin:$PATH"
  fi
  uv tool install graphifyy || return 1
  graphify install || return 1
  graphify install --platform cursor || return 1
  graphify hook install || return 1
  graphify update . || return 1
}
if ! graphify_phase; then
  echo "WARN: Graphify phase failed — continuing to sdd-kit install (manual install: guide §2)"
fi

banner kit
echo ""
echo "==> SDD Install Kit (payloads)..."
if [[ -f "$REPO/sdd-kit/install.sh" ]]; then
  # Profile: explicit --profile wins; else detect HYBRID from the pre-init snapshot (D1/D2)
  if [[ -n "$PROFILE_FLAG" ]]; then
    PROFILE="$PROFILE_FLAG"
  elif [[ -f "$REPO/package.json" ]] && $PRE_INIT_HAD_OPENSPEC; then
    echo "WARN: package.json and openspec/ coexist — profile may be HYBRID." >&2
    echo "      Confirm: rerun with --profile HYBRID or DOCS_SPECS if not APP." >&2
    echo "      Continuing with --profile APP by default (rerun with --profile APP|DOCS_SPECS|HYBRID to override)." >&2
    PROFILE="APP"
  elif [[ -f "$REPO/package.json" ]]; then
    PROFILE="APP"
  else
    PROFILE="DOCS_SPECS"
  fi
  INSTALL_ARGS=(--profile "$PROFILE" --repo "$REPO")
  if [[ "$CHAT_LANG" == "pt-BR" || "$CHAT_LANG" == "en" ]]; then
    INSTALL_ARGS+=(--chat-lang "$CHAT_LANG")
  fi
  bash "$REPO/sdd-kit/install.sh" "${INSTALL_ARGS[@]}" || {
    echo "WARN: sdd-kit/install.sh failed — run manually after editing project.md profile"
  }
else
  echo "WARN: sdd-kit/install.sh not found — copy kit from hub or run after add-sdd-install-kit"
fi

echo ""
echo "Done. Manual steps (required):"
echo "  1. Edit openspec/project.md"
echo "  2. Merge AGENTS.md if install.sh kept existing file (templates: sdd-kit/templates/AGENTS.core.md)"
echo "  3. Language policy: use install.sh flags (--chat-lang, --docs-lang, --code-lang) or see guide §2.1.1"
echo "  4. Do NOT paste full gitnexus:start blocks into AGENTS.md"
echo "  5. bash sdd-kit/verify.sh + checklist section 2.8 in the guide"
echo "  6. Restart IDE; test /opsx:propose"
echo "  7. Day-1 operate: /opsx:help (map) then /opsx:onboard (practice — upstream OpenSpec)"
