#!/usr/bin/env bash
# Bootstrap SDD — see doc/byebyevibe-guide.md §2 / §12.6
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
        APP|DOCS_SPECS) ;;
        HYBRID)
          echo "DEPRECATED: --profile HYBRID is deprecated — equivalent to APP since kit 1.9.0; using APP" >&2
          PROFILE_FLAG="APP"
          ;;
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

# Hub-mode resolution (D2): the repo containing this running script. When the
# target lacks preflight/kit, fall back here; target-local copies always win.
SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO"
REPO="$(pwd)"

# AGENTS.md snapshot (D9) — taken before ANY phase runs, because `openspec init` and
# the knowledge CLIs create or append to AGENTS.md themselves. Run last in C1 order
# (which MUST NOT change), install.sh cannot tell a tool-generated AGENTS.md from an
# operator's own file and used to KEEP the tool output; this variable can.
if [[ -f "$REPO/AGENTS.md" ]]; then
  SDD_AGENTS_PREEXISTED=1
else
  SDD_AGENTS_PREEXISTED=0
fi
export SDD_AGENTS_PREEXISTED

# Phase 0 — Preflight (full --all) before OpenSpec unless --skip-preflight
if ! $SKIP_PREFLIGHT; then
  PREFLIGHT_SCRIPT=""
  if [[ -f "$REPO/scripts/preflight-sdd.sh" ]]; then
    PREFLIGHT_SCRIPT="$REPO/scripts/preflight-sdd.sh"
  elif [[ -f "$REPO/sdd-kit/templates/scripts/preflight-sdd.sh" ]]; then
    PREFLIGHT_SCRIPT="$REPO/sdd-kit/templates/scripts/preflight-sdd.sh"
  elif [[ -f "$SOURCE_ROOT/scripts/preflight-sdd.sh" ]]; then
    PREFLIGHT_SCRIPT="$SOURCE_ROOT/scripts/preflight-sdd.sh"
  elif [[ -f "$SOURCE_ROOT/sdd-kit/templates/scripts/preflight-sdd.sh" ]]; then
    PREFLIGHT_SCRIPT="$SOURCE_ROOT/sdd-kit/templates/scripts/preflight-sdd.sh"
  fi
  if [[ -z "$PREFLIGHT_SCRIPT" ]]; then
    echo "ERROR: preflight-sdd.sh not found (tried target and source scripts/ and sdd-kit/templates/scripts/)." >&2
    echo "       Copy kit from hub, or pass --skip-preflight to bypass phase 0." >&2
    exit 1
  fi
  # Hub mode: target has no kit but the source root does — let the repo gate
  # accept the source root's sdd-kit/ (target-local kit still wins).
  PREFLIGHT_ARGS=(--all --repo-root "$REPO")
  if [[ ! -f "$REPO/sdd-kit/install.sh" && -f "$SOURCE_ROOT/sdd-kit/install.sh" ]]; then
    PREFLIGHT_ARGS+=(--kit-root "$SOURCE_ROOT")
  fi
  echo "==> Phase 0 — Preflight ($PREFLIGHT_SCRIPT --all)..."
  bash "$PREFLIGHT_SCRIPT" "${PREFLIGHT_ARGS[@]}" || {
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
        echo "Escopo: instala uma vez na sua máquina — projetos futuros reutilizam"
        ;;
      gitnexus)
        echo "--- GitNexus ---"
        echo "O que: O mapa do código do seu repo"
        echo "Sem ela, a IA mexe no feeling e quebra o lado"
        echo "Escopo: instala uma vez na sua máquina — projetos futuros reutilizam"
        ;;
      graphify)
        echo "--- Graphify ---"
        echo "O que: O mapa do que o time já sabe (docs, decisões, ideias)"
        echo "Sem ela, a IA reinventa o que o time já escreveu"
        echo "Escopo: instala uma vez na sua máquina — projetos futuros reutilizam"
        ;;
      kit)
        echo "--- sdd-kit ---"
        echo "O que: A caixa de ferramentas que liga tudo isso no seu projeto"
        echo "Sem ela, cada repo monta o processo do zero"
        echo "Escopo: copiado para este repo — cada projeto tem o seu"
        ;;
    esac
  else
    case "$tool" in
      openspec)
        echo "--- OpenSpec ---"
        echo "What: The playbook for a change: think → agree → do → keep a record"
        echo "Without it, chat turns into code and nobody remembers why"
        echo "Scope: installs once on your machine — future projects reuse it"
        ;;
      gitnexus)
        echo "--- GitNexus ---"
        echo "What: The map of your repo's code"
        echo "Without it, the AI edits by vibe and breaks the neighborhood"
        echo "Scope: installs once on your machine — future projects reuse it"
        ;;
      graphify)
        echo "--- Graphify ---"
        echo "What: The map of what the team already knows (docs, decisions, ideas)"
        echo "Without it, the AI reinvents what the team already wrote"
        echo "Scope: installs once on your machine — future projects reuse it"
        ;;
      kit)
        echo "--- sdd-kit ---"
        echo "What: The toolbox that wires the control plane into this repo"
        echo "Without it, every repo invents the process from scratch"
        echo "Scope: copied into this repo — each project gets its own"
        ;;
    esac
  fi
  echo ""
}

# Idempotent guard (D3): package-manager installs are skipped when the tool is
# already on PATH. Skip notices are phase-level diagnostics — they print
# regardless of TTY/--quiet, like the ==> phase markers.
skip_notice() {
  local tool="$1" ver
  ver="$("$tool" --version 2>/dev/null | head -1 || true)"
  if [[ -n "$ver" ]]; then
    echo "==> $tool already installed ($ver) — skipping install"
  else
    echo "==> $tool already installed — skipping install"
  fi
}

# Returns 0 if version $1 >= $2 (major.minor.patch; non-numeric parts stripped)
version_ge() {
  local a1 a2 a3 b1 b2 b3
  IFS=. read -r a1 a2 a3 <<<"$1."
  IFS=. read -r b1 b2 b3 <<<"$2."
  a1=${a1//[^0-9]/}; a2=${a2//[^0-9]/}; a3=${a3//[^0-9]/}
  b1=${b1//[^0-9]/}; b2=${b2//[^0-9]/}; b3=${b3//[^0-9]/}
  a1=${a1:-0}; a2=${a2:-0}; a3=${a3:-0}
  b1=${b1:-0}; b2=${b2:-0}; b3=${b3:-0}
  if (( a1 != b1 )); then (( a1 > b1 )); return; fi
  if (( a2 != b2 )); then (( a2 > b2 )); return; fi
  (( a3 >= b3 ))
}

# Staleness safety net (D3): WARN (never abort) when detected openspec is older
# than MANIFEST min_openspec; comparison failure degrades to a notice.
warn_stale_openspec() {
  local manifest="" min detected
  if [[ -f "$REPO/sdd-kit/MANIFEST.yaml" ]]; then
    manifest="$REPO/sdd-kit/MANIFEST.yaml"
  elif [[ -f "$SOURCE_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
    manifest="$SOURCE_ROOT/sdd-kit/MANIFEST.yaml"
  fi
  if [[ -z "$manifest" ]]; then
    echo "NOTE: no sdd-kit/MANIFEST.yaml found — skipping min_openspec staleness check"
    return 0
  fi
  min="$(sed -n 's/^min_openspec:[[:space:]]*"\{0,1\}\([0-9][0-9.]*\).*/\1/p' "$manifest" | head -1)"
  detected="$(openspec --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
  if [[ -z "$min" || -z "$detected" ]]; then
    echo "NOTE: could not compare openspec version against MANIFEST min_openspec — skipping staleness check"
    return 0
  fi
  if ! version_ge "$detected" "$min"; then
    echo "WARN: openspec $detected is older than MANIFEST min_openspec $min — refresh CLIs via scenario C2b (guide §2.9.4)"
  fi
  return 0
}

banner openspec
echo "==> OpenSpec..."
if command -v openspec &>/dev/null; then
  skip_notice openspec
  warn_stale_openspec
else
  npm install -g @fission-ai/openspec@latest
fi
# Diagnostics are captured, never discarded (D10, sdd-fail-loud): the first attempt's
# stderr used to go to /dev/null, so the likelier failure was invisible and the abort
# that followed named no culprit.
OPENSPEC_INIT_LOG="$(mktemp)"
if ! openspec init --tools "cursor,claude" "$REPO" >"$OPENSPEC_INIT_LOG" 2>&1; then
  echo "WARN: 'openspec init <target>' failed — retrying in the current directory. Output was:" >&2
  cat "$OPENSPEC_INIT_LOG" >&2
  if ! openspec init --tools "cursor,claude" >>"$OPENSPEC_INIT_LOG" 2>&1; then
    echo "ERROR: openspec init failed (both the explicit-target and current-directory invocations) — aborting bootstrap." >&2
    cat "$OPENSPEC_INIT_LOG" >&2
    rm -f "$OPENSPEC_INIT_LOG"
    exit 1
  fi
fi
rm -f "$OPENSPEC_INIT_LOG"

banner gitnexus
echo "==> GitNexus (optional — does not abort bootstrap on failure)..."
GITNEXUS_READY=true
if command -v gitnexus &>/dev/null; then
  skip_notice gitnexus
elif ! npm install -g gitnexus; then
  GITNEXUS_READY=false
  echo "WARN: GitNexus install failed (e.g. onnxruntime native binary blocked by network) — continuing without GitNexus"
fi
if $GITNEXUS_READY; then
  gitnexus setup || echo "WARN: 'gitnexus setup' failed — continuing"
  gitnexus analyze || echo "WARN: 'gitnexus analyze' failed — continuing"
fi

banner graphify
echo "==> Graphify (optional — does not abort bootstrap on failure)..."
graphify_phase() {
  if command -v graphify &>/dev/null; then
    skip_notice graphify
  else
    if command -v uv &>/dev/null; then
      skip_notice uv
    else
      curl -LsSf https://astral.sh/uv/install.sh | sh || return 1
      export PATH="$HOME/.local/bin:$PATH"
    fi
    uv tool install graphifyy || return 1
  fi
  # Repo-scoped / idempotent steps: always run, even when the CLI was skipped
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
KIT_INSTALL=""
if [[ -f "$REPO/sdd-kit/install.sh" ]]; then
  KIT_INSTALL="$REPO/sdd-kit/install.sh"
elif [[ -f "$SOURCE_ROOT/sdd-kit/install.sh" ]]; then
  KIT_INSTALL="$SOURCE_ROOT/sdd-kit/install.sh"
  echo "==> Hub mode: target has no sdd-kit/ — installing payload from $SOURCE_ROOT"
fi
if [[ -n "$KIT_INSTALL" ]]; then
  # Profile: explicit --profile wins; else detect HYBRID from the pre-init snapshot (D1/D2)
  if [[ -n "$PROFILE_FLAG" ]]; then
    PROFILE="$PROFILE_FLAG"
  elif [[ -f "$REPO/package.json" ]]; then
    PROFILE="APP"
  else
    PROFILE="DOCS_SPECS"
  fi
  INSTALL_ARGS=(--profile "$PROFILE" --repo "$REPO")
  if [[ "$CHAT_LANG" == "pt-BR" || "$CHAT_LANG" == "en" ]]; then
    INSTALL_ARGS+=(--chat-lang "$CHAT_LANG")
  fi
  # Fatal, not WARN (D2, sdd-fail-loud): the payload is the reason this command exists.
  # GitNexus/Graphify stay optional above — they are integrations, not the kit itself.
  bash "$KIT_INSTALL" "${INSTALL_ARGS[@]}" || {
    echo "ERROR: sdd-kit/install.sh failed — the SDD payload was NOT installed. Bootstrap aborted." >&2
    echo "       Fix the reported cause and re-run, or run '$KIT_INSTALL --profile $PROFILE --repo $REPO' manually." >&2
    exit 1
  }
else
  echo "ERROR: sdd-kit/install.sh not found (neither in the target nor in $SOURCE_ROOT) — no payload could be installed. Bootstrap aborted." >&2
  echo "       Copy the kit from the hub (or run bootstrap from a hub clone) and re-run." >&2
  exit 1
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

# Didactic completion message (D4): TTY-only, suppressed by --quiet — printed
# after the unconditional manual-steps block above (which must stay unchanged).
if $SHOW_BANNERS; then
  echo ""
  if [[ "$CHAT_LANG" == "pt-BR" ]]; then
    echo "--- Escopo de instalação ---"
    echo "O estado durável deste projeto vive em openspec/, graphify-out/ e .gitnexus/ —"
    echo "dentro da pasta do projeto, nunca compartilhado entre projetos."
    if [[ -d "$SOURCE_ROOT/sdd-kit" ]]; then
      echo "Próximo projeto: o mesmo comando único com um novo destino:"
      echo "  bash $SOURCE_ROOT/scripts/bootstrap-sdd.sh <novo-destino> --profile <PROFILE>"
    else
      echo "Próximo projeto: rode o bootstrap a partir de um clone do hub (esta instalação não carrega sdd-kit/) — veja o guia §1.6."
    fi
  else
    echo "--- Install scope ---"
    echo "This project's durable state now lives in openspec/, graphify-out/ and .gitnexus/ —"
    echo "inside the project folder, never shared between projects."
    if [[ -d "$SOURCE_ROOT/sdd-kit" ]]; then
      echo "Next project: the same single command with a new target path:"
      echo "  bash $SOURCE_ROOT/scripts/bootstrap-sdd.sh <new-target> --profile <PROFILE>"
    else
      echo "Next project: run bootstrap from a hub clone (this install carries no sdd-kit/) — see guide §1.6."
    fi
  fi
fi
