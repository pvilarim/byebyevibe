#!/usr/bin/env bash
# verify-i18n-wave.sh — Per-wave and global PT→EN migration gates (sdd-docs-language)
#
# Gates: G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC, G-DoD (--dod)
# Deny-list (G-PT / G-DoD): curated high-signal Portuguese tokens below (PT_DENY_REGEX).
# Allowlist / freeze notes: doc/i18n/GLOSSARY.md · wave inventory: doc/i18n/WAVES.md
#
# Usage:
#   bash scripts/verify-i18n-wave.sh --files path/a.md,path/b.md
#   bash scripts/verify-i18n-wave.sh --files path/a.md --slice 1-132
#   bash scripts/verify-i18n-wave.sh --dod
#   bash scripts/verify-i18n-wave.sh --help
#
# Exit 0 = pass; non-zero = fail-closed. No secrets. No network beyond hub OpenSpec validate (npx).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FAILURES=0
MODE=""
FILES_CSV=""
SLICE_START=""
SLICE_END=""
slice_arg=""
declare -a WAVE_FILES=()

# High-signal PT prose tokens (word-ish). Avoid short ambiguous tokens (e.g. "para", "com").
# Documented also in doc/i18n/WAVES.md. Expand carefully — false positives need allowlist notes.
PT_DENY_REGEX='não|também|ficheiro|ficheiros|sessão|sessões|mudança|mudanças|proposta|propostas|habilidade|habilidades|arquivar|arquivado|glossário|inventário|através|apenas|qualquer|conforme|secção|secções|seção|seções|ficará|deve-se|requisito|requisitos|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|avaliações|canónico|canónica|actualmente|atualização|actualização|próximo|próxima|depois de|antes de|durante o|quando o|então o|não há|não deve|não pode'

# Freeze / invariant fragments that must not appear as "translated" forms in wave files.
# If a denylist "translated command" form is found, G-INV fails.
INV_BAD_REGEX='/opsx:aplicar|/opsx:propor|/opsx:explorar|/opsx:arquivar|openspec validar|verificar-i18n-onda|kit-de-instalação'

usage() {
  cat <<'EOF'
verify-i18n-wave.sh — i18n / docs-language verification (sdd-docs-language)

Usage:
  bash scripts/verify-i18n-wave.sh --files path1,path2,...
  bash scripts/verify-i18n-wave.sh --files path1 --slice START-END
  bash scripts/verify-i18n-wave.sh --dod
  bash scripts/verify-i18n-wave.sh --help

Optional --slice START-END (with --files): limit G-INV, G-PT, and G-LINK to a line
range in each touched file (mid-file guide/design slices). Whole-file scan when omitted.

Gates (per --files wave):
  G-INV      Freeze-list / invariant check (no translated command forms)
  G-GLOSS    Glossary file present; key canonical EN terms present in glossary
  G-PT       Portuguese prose deny-list on wave files
  G-LINK     Relative markdown links resolve for touched .md files
  G-MIRROR   .cursor ↔ .claude skill/command pairs stay listed and content-equivalent
  G-MANIFEST Touched sdd-kit/templates/ → kit verify integrity (when applicable)
  G-OPENSPEC openspec validate --all --strict (pinned CLI, OPENSPEC_TELEMETRY=0)

Gates (--dod):
  G-DoD      Global residual-PT scan over in-scope surfaces from doc/i18n/WAVES.md
  (+ G-GLOSS, G-OPENSPEC)

Exit 0 on pass; non-zero on failure. Mode C for waves — not a blocking sdd-gates CI step by default.
EOF
}

fail() {
  echo "  FAIL $*"
  ((FAILURES++)) || true
}

ok() {
  echo "  OK   $*"
}

warn() {
  echo "  WARN $*"
}

# --- arg parse ---
if [[ $# -eq 0 ]]; then
  usage
  exit 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --files)
      MODE="files"
      FILES_CSV="${2:-}"
      if [[ -z "$FILES_CSV" ]]; then
        echo "error: --files requires a comma-separated list" >&2
        exit 2
      fi
      shift 2
      ;;
    --dod)
      MODE="dod"
      shift
      ;;
    --slice)
      slice_arg="${2:-}"
      if [[ -z "$slice_arg" || ! "$slice_arg" =~ ^[0-9]+-[0-9]+$ ]]; then
        echo "error: --slice requires START-END (e.g. 1-132)" >&2
        exit 2
      fi
      SLICE_START="${slice_arg%-*}"
      SLICE_END="${slice_arg#*-}"
      if [[ "$SLICE_START" -gt "$SLICE_END" ]]; then
        echo "error: --slice START must be <= END" >&2
        exit 2
      fi
      shift 2
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  usage
  exit 2
fi

# --- helpers ---
split_files() {
  local csv="$1"
  local IFS=','
  # shellcheck disable=SC2206
  WAVE_FILES=($csv)
}

# Glossary always contains legacy pt-BR → EN rows; skip PT scan there.
is_pt_scan_exempt() {
  local f="$1"
  case "$f" in
    doc/i18n/GLOSSARY.md|./doc/i18n/GLOSSARY.md) return 0 ;;
  esac
  return 1
}

file_content() {
  local f="$1"
  if [[ -n "$SLICE_START" && -n "$SLICE_END" ]]; then
    sed -n "${SLICE_START},${SLICE_END}p" "$f"
  else
    cat "$f"
  fi
}

file_has_pt() {
  local f="$1"
  if is_pt_scan_exempt "$f"; then
    return 1
  fi
  if file_content "$f" | grep -Eiq "$PT_DENY_REGEX" 2>/dev/null; then
    return 0
  fi
  return 1
}

# --- G-GLOSS ---
gate_gloss() {
  echo "==> G-GLOSS"
  local gloss="doc/i18n/GLOSSARY.md"
  if [[ ! -s "$gloss" ]]; then
    fail "missing or empty $gloss"
    return
  fi
  local missing=0
  for term in change propose apply gate "Session Handoff" skill wave glossary; do
    if ! grep -qiE "$term" "$gloss"; then
      fail "glossary missing expected term hint: $term"
      missing=1
    fi
  done
  if [[ "$missing" -eq 0 ]]; then
    ok "glossary present with canonical term hints"
  fi
}

# --- G-INV ---
gate_inv() {
  echo "==> G-INV"
  local f
  local bad=0
  for f in "${WAVE_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
      fail "G-INV file missing: $f"
      bad=1
      continue
    fi
    if file_content "$f" | grep -Eiq "$INV_BAD_REGEX" 2>/dev/null; then
      fail "G-INV translated/frozen form in $f (matches denylist command forms)"
      bad=1
    fi
  done
  if [[ "$bad" -eq 0 ]]; then
    ok "no forbidden translated command forms in wave files"
  fi
}

# --- G-PT ---
gate_pt() {
  echo "==> G-PT"
  local f
  local bad=0
  for f in "${WAVE_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
      fail "G-PT file missing: $f"
      bad=1
      continue
    fi
    if file_has_pt "$f"; then
      # Show first matching line for operator
      local hit
      if [[ -n "$SLICE_START" && -n "$SLICE_END" ]]; then
        hit="$(file_content "$f" | grep -Ein "$PT_DENY_REGEX" 2>/dev/null | head -3 || true)"
      else
        hit="$(grep -Ein "$PT_DENY_REGEX" "$f" 2>/dev/null | head -3 || true)"
      fi
      fail "G-PT residual Portuguese tokens in $f"
      [[ -n "$hit" ]] && echo "$hit" | sed 's/^/         /'
      bad=1
    fi
  done
  if [[ "$bad" -eq 0 ]]; then
    ok "no deny-listed Portuguese prose in wave files"
  fi
}

# --- G-LINK ---
gate_link() {
  echo "==> G-LINK"
  local f
  local bad=0
  for f in "${WAVE_FILES[@]}"; do
    [[ -f "$f" ]] || continue
    [[ "$f" == *.md || "$f" == *.mdc ]] || continue
    local dir
    dir="$(dirname "$f")"
    # Extract markdown links: [text](url) — skip http(s), mailto, anchors-only, #
    while IFS= read -r url || [[ -n "$url" ]]; do
      [[ -z "$url" ]] && continue
      if [[ "$url" =~ ^https?:// ]] || [[ "$url" =~ ^mailto: ]] || [[ "$url" =~ ^# ]]; then
        continue
      fi
      # Strip optional anchor
      local path_part="${url%%#*}"
      [[ -z "$path_part" ]] && continue
      local target
      if [[ "$path_part" == /* ]]; then
        target="${REPO_ROOT}${path_part}"
      else
        target="$dir/$path_part"
      fi
      # Normalize .. components roughly
      if [[ ! -e "$target" ]]; then
        # Also try from repo root for repo-relative links
        if [[ ! -e "$REPO_ROOT/$path_part" ]]; then
          fail "G-LINK broken relative link in $f → $url"
          bad=1
        fi
      fi
    done < <(file_content "$f" | grep -oE '\[[^]]*\]\([^)]+\)' 2>/dev/null | sed -E 's/.*\(([^)]+)\).*/\1/' || true)
  done
  if [[ "$bad" -eq 0 ]]; then
    ok "relative markdown links resolve for touched markdown files"
  fi
}

# --- G-MIRROR ---
mirror_peer() {
  local f="$1"
  if [[ "$f" == .cursor/skills/* || "$f" == .cursor/commands/* ]]; then
    echo "${f/.cursor\//.claude/}"
  elif [[ "$f" == .claude/skills/* || "$f" == .claude/commands/* ]]; then
    echo "${f/.claude\//.cursor/}"
  else
    echo ""
  fi
}

gate_mirror() {
  echo "==> G-MIRROR"
  local f peer
  local bad=0
  local checked=0
  for f in "${WAVE_FILES[@]}"; do
    peer="$(mirror_peer "$f")"
    [[ -z "$peer" ]] && continue
    checked=1
    # Peer must be in WAVE_FILES
    local listed=0
    local w
    for w in "${WAVE_FILES[@]}"; do
      if [[ "$w" == "$peer" ]]; then
        listed=1
        break
      fi
    done
    if [[ "$listed" -eq 0 ]]; then
      fail "G-MIRROR $f requires peer $peer in --files"
      bad=1
      continue
    fi
    if [[ -f "$f" && -f "$peer" ]]; then
      if ! cmp -s "$f" "$peer"; then
        fail "G-MIRROR content differs: $f ↔ $peer"
        bad=1
      fi
    elif [[ -f "$f" && ! -f "$peer" ]]; then
      fail "G-MIRROR missing peer file: $peer (for $f)"
      bad=1
    elif [[ ! -f "$f" && -f "$peer" ]]; then
      fail "G-MIRROR missing file: $f (peer exists: $peer)"
      bad=1
    fi
  done
  if [[ "$checked" -eq 0 ]]; then
    ok "no skill/command mirror paths in --files (skip)"
  elif [[ "$bad" -eq 0 ]]; then
    ok "cursor/claude mirrors listed and content-equivalent"
  fi
}

# --- G-MANIFEST ---
gate_manifest() {
  echo "==> G-MANIFEST"
  local f
  local touched_templates=0
  for f in "${WAVE_FILES[@]}"; do
    if [[ "$f" == sdd-kit/templates/* ]]; then
      touched_templates=1
      break
    fi
  done
  if [[ "$touched_templates" -eq 0 ]]; then
    ok "no sdd-kit/templates/ paths in --files (skip)"
    return
  fi
  if [[ ! -x "sdd-kit/verify.sh" ]]; then
    fail "G-MANIFEST sdd-kit/verify.sh missing or not executable"
    return
  fi
  if bash sdd-kit/verify.sh >/tmp/verify-i18n-manifest.txt 2>&1; then
    ok "sdd-kit/verify.sh passed after templates touch"
  else
    fail "G-MANIFEST sdd-kit/verify.sh failed — run bash sdd-kit/gen-manifest-checksums.sh?"
    tail -20 /tmp/verify-i18n-manifest.txt | sed 's/^/         /' || true
  fi
}

# --- G-OPENSPEC ---
gate_openspec() {
  echo "==> G-OPENSPEC"
  if OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict >/tmp/verify-i18n-openspec.txt 2>&1; then
    ok "openspec validate --all --strict"
  else
    fail "openspec validate --all --strict failed"
    tail -30 /tmp/verify-i18n-openspec.txt | sed 's/^/         /' || true
  fi
}

# Collect DoD file list from inventory globs (WAVES.md documented surfaces)
collect_dod_files() {
  local -a paths=()
  local p
  for p in \
    AGENTS.md CLAUDE.md README.md \
    openspec/project.md openspec/infra.md \
    doc/sistema-sdd-pedro.md
  do
    [[ -f "$p" ]] && paths+=("$p")
  done
  while IFS= read -r -d '' p; do
    paths+=("${p#./}")
  done < <(find .cursor/rules .cursor/skills .cursor/commands \
    .claude/skills .claude/commands \
    doc/avaliacoes doc/design doc/i18n \
    openspec/specs \
    \( -name '*.md' -o -name '*.mdc' \) -print0 2>/dev/null || true)
  # Note: doc/curso/ excluded from G-DoD (human decision — WCu OUT in WAVES.md)
  while IFS= read -r -d '' p; do
    paths+=("${p#./}")
  done < <(find sdd-kit -path 'sdd-kit/templates/*' \( -name '*.md' -o -name '*.mdc' \) -print0 2>/dev/null; \
    find sdd-kit -maxdepth 1 -name 'README.md' -print0 2>/dev/null || true)
  # Active changes (exclude archive)
  while IFS= read -r -d '' p; do
    paths+=("${p#./}")
  done < <(find openspec/changes -mindepth 2 -maxdepth 3 \
    \( -name 'proposal.md' -o -name 'design.md' -o -name 'tasks.md' -o -name 'spec.md' \) \
    ! -path 'openspec/changes/archive/*' -print0 2>/dev/null || true)

  # Deduplicate
  printf '%s\n' "${paths[@]}" | awk 'NF && !seen[$0]++'
}

gate_dod() {
  echo "==> G-DoD (global residual PT scan)"
  local f
  local bad=0
  local count=0
  local hits=0
  while IFS= read -r f; do
    [[ -z "$f" || ! -f "$f" ]] && continue
    ((count++)) || true
    if file_has_pt "$f"; then
      ((hits++)) || true
      if [[ "$hits" -le 25 ]]; then
        fail "G-DoD residual PT in $f"
      fi
      bad=1
    fi
  done < <(collect_dod_files)
  echo "  scanned $count in-scope files; residual hits reported: $hits (capped display 25)"
  if [[ "$bad" -eq 0 ]]; then
    ok "no deny-listed Portuguese prose on in-scope surfaces"
  else
    warn "global DoD not met — continue translate-*-wave-N until residual ≈ 0"
  fi
}

# --- main ---
echo "==> verify-i18n-wave.sh (mode: $MODE)"

gate_gloss

if [[ "$MODE" == "files" ]]; then
  split_files "$FILES_CSV"
  local_missing=0
  for f in "${WAVE_FILES[@]}"; do
    if [[ ! -e "$f" ]]; then
      fail "wave file does not exist: $f"
      local_missing=1
    fi
  done
  if [[ "$local_missing" -ne 0 ]]; then
    echo "Summary: ${FAILURES} failure(s) ❌"
    exit 1
  fi
  gate_inv
  gate_pt
  gate_link
  gate_mirror
  gate_manifest
  gate_openspec
elif [[ "$MODE" == "dod" ]]; then
  gate_dod
  gate_openspec
fi

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: all requested gates OK ✅"
  exit 0
else
  echo "Summary: ${FAILURES} gate failure(s) ❌"
  exit 1
fi
