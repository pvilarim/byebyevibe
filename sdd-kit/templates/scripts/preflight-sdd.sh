#!/usr/bin/env bash
# Phase-0 SDD install preflight — host/repo prerequisite checks before C1.
# See: openspec/specs/sdd-install-preflight, design D1–D6 (add-sdd-install-preflight)
#
# Updates openspec/infra.md "## Preflight (last run)" markers only.
# Does NOT touch SDD Stack markers (openspec-*, gitnexus-*, graphify-*, mcp-list, kit-*).
# verify-infra.sh MUST NOT write preflight-* markers.
set -euo pipefail

MODE=""
JSON=false
PROFILE=""
REPO_ROOT="."
KIT_ROOT=""
FAIL_COUNT=0
WARN_COUNT=0
SKIP_COUNT=0

# Accumulated check records for --json: id|level|message
declare -a CHECK_RECORDS=()
declare -a WARN_MESSAGES=()
declare -a IDE_DETECTED=()
MCP_NAMES=""

usage() {
  cat <<'EOF'
Usage: preflight-sdd.sh [--host|--repo|--all] [--json] [--profile APP|DOCS_SPECS|HYBRID]
                        [--repo-root PATH] [--kit-root PATH]

Phase-0 prerequisite checks before C1 (bootstrap / install).

Modes (default: --all when none given):
  --host        Host tools: git, node≥20.19, npm, Python≥3.8 (kit floor; Graphify 3.10 is WARN); WARN for uv, build tools, IDE, MCP
  --repo        Repo gate: sdd-kit/ readable, repo writable; WARN for ambiguous HYBRID hints
  --all         Host + repo (default)

Options:
  --json        Emit JSON summary on stdout (human lines still on stderr when useful)
  --profile     Severity wording for GitNexus build-tools WARN (APP|DOCS_SPECS|HYBRID)
  --repo-root   Repository root (default: .)
  --kit-root    Source kit root (hub mode): when the target repo has no sdd-kit/,
                the kit-presence check passes if PATH/sdd-kit is readable
                (passed by bootstrap-sdd.sh hub-mode resolution)
  -h, --help    Show this help

Exit: non-zero if any FAIL; zero on WARN/SKIP only.
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) MODE="host"; shift ;;
    --repo) MODE="repo"; shift ;;
    --all) MODE="all"; shift ;;
    --json) JSON=true; shift ;;
    --profile)
      PROFILE="${2:-}"
      [[ -n "$PROFILE" ]] || { echo "ERROR: --profile requires a value" >&2; usage 2; }
      shift 2
      ;;
    --repo-root)
      REPO_ROOT="${2:-}"
      [[ -n "$REPO_ROOT" ]] || { echo "ERROR: --repo-root requires a path" >&2; usage 2; }
      shift 2
      ;;
    --kit-root)
      KIT_ROOT="${2:-}"
      [[ -n "$KIT_ROOT" ]] || { echo "ERROR: --kit-root requires a path" >&2; usage 2; }
      shift 2
      ;;
    -h|--help) usage 0 ;;
    *)
      echo "ERROR: unknown option: $1" >&2
      usage 2
      ;;
  esac
done

[[ -n "$MODE" ]] || MODE="all"

case "$PROFILE" in
  ""|APP|DOCS_SPECS|HYBRID) ;;
  *)
    echo "ERROR: invalid --profile '$PROFILE' (allowed: APP, DOCS_SPECS, HYBRID)" >&2
    exit 2
    ;;
esac

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
cd "$REPO_ROOT"

log_human() {
  # Always human-facing lines to stderr so --json keeps stdout clean
  echo "$@" >&2
}

# --- Python resolution (fix-install-python-boundary, design D1/D3) ---
# Resolve a usable interpreter by capability, not by the name `python3`
# (the CPython Windows installer never creates python3.exe). Candidates are
# NAMES, never paths; "py -3" is two words, so every expansion of
# $SDD_PYTHON is deliberately unquoted — do not "fix" the quoting.
# SDD_PYTHON from the environment is trusted as-is (no re-probing).
# Candidate order: version-suffixed rungs give macOS real alternatives (an unsuffixed
# `python3` often does not exist there), and `/usr/bin/python3` comes last because it may
# be the Xcode CLT shim — probing it can be slow or trigger a GUI prompt, so it is only
# reached once every other rung has failed.
SDD_PYTHON="${SDD_PYTHON:-}"
SDD_PYTHON_VERSION=""
resolve_python() {
  if [[ -n "$SDD_PYTHON" ]]; then
    SDD_PYTHON_VERSION="${SDD_PYTHON_VERSION:-(env override)}"
    return 0
  fi
  local c v
  for c in "python3" "python3.14" "python3.13" "python" "py -3" "/usr/bin/python3"; do
    # Probe by execution (command -v cannot probe a two-word candidate and
    # succeeds for the Windows Store alias stub, which is not a Python).
    v="$($c -c 'import sys; print("%d.%d.%d" % sys.version_info[:3])' 2>/dev/null)" || true
    [[ -n "$v" ]] || continue
    # Kit floor 3.8 — the kit's own scripts; Graphify's 3.10 is checked separately.
    if $c -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 8) else 1)' 2>/dev/null; then
      SDD_PYTHON="$c"
      SDD_PYTHON_VERSION="$v"
      return 0
    fi
  done
  return 1
}

record_check() {
  local id="$1" level="$2" message="$3"
  CHECK_RECORDS+=("${id}|${level}|${message}")
  case "$level" in
    FAIL)
      ((FAIL_COUNT++)) || true
      log_human "FAIL: [$id] $message"
      ;;
    WARN)
      ((WARN_COUNT++)) || true
      WARN_MESSAGES+=("$message")
      log_human "WARN: [$id] $message"
      ;;
    SKIP)
      ((SKIP_COUNT++)) || true
      log_human "SKIP: [$id] $message"
      ;;
    OK)
      log_human "OK:   [$id] $message"
      ;;
    *)
      log_human "$level: [$id] $message"
      ;;
  esac
}

# Compare dotted versions: returns 0 if $1 >= $2 (major.minor.patch, missing parts = 0)
version_ge() {
  local a="$1" b="$2"
  local a1 a2 a3 b1 b2 b3
  IFS=. read -r a1 a2 a3 <<<"${a}."
  IFS=. read -r b1 b2 b3 <<<"${b}."
  a1=${a1:-0}; a2=${a2:-0}; a3=${a3:-0}
  b1=${b1:-0}; b2=${b2:-0}; b3=${b3:-0}
  a1=${a1//[^0-9]/}; a2=${a2//[^0-9]/}; a3=${a3//[^0-9]/}
  b1=${b1//[^0-9]/}; b2=${b2//[^0-9]/}; b3=${b3//[^0-9]/}
  a1=${a1:-0}; a2=${a2:-0}; a3=${a3:-0}
  b1=${b1:-0}; b2=${b2:-0}; b3=${b3:-0}
  if (( a1 > b1 )); then return 0; fi
  if (( a1 < b1 )); then return 1; fi
  if (( a2 > b2 )); then return 0; fi
  if (( a2 < b2 )); then return 1; fi
  if (( a3 >= b3 )); then return 0; fi
  return 1
}

detect_profile_hint() {
  if [[ -n "$PROFILE" ]]; then
    echo "$PROFILE"
    return
  fi
  if [[ -f "$REPO_ROOT/package.json" ]]; then
    echo "APP"
  else
    echo "DOCS_SPECS"
  fi
}

EFFECTIVE_PROFILE="$(detect_profile_hint)"

check_host() {
  log_human "==> preflight host ($REPO_ROOT)"

  # Git
  if command -v git &>/dev/null; then
    record_check "git" "OK" "$(git --version 2>/dev/null | head -1)"
  else
    record_check "git" "FAIL" "git not found on PATH (required for C1)"
  fi

  # Node ≥ 20.19.0
  if command -v node &>/dev/null; then
    local node_ver
    node_ver="$(node -v 2>/dev/null | sed 's/^v//')"
    if version_ge "$node_ver" "20.19.0"; then
      record_check "node" "OK" "node v${node_ver}"
    else
      record_check "node" "FAIL" "node v${node_ver} < minimum 20.19.0"
    fi
  else
    record_check "node" "FAIL" "node not found on PATH (required for OpenSpec/GitNexus)"
  fi

  # npm
  if command -v npm &>/dev/null; then
    record_check "npm" "OK" "npm $(npm --version 2>/dev/null)"
  else
    record_check "npm" "FAIL" "npm not found on PATH"
  fi

  # Python — kit floor 3.8 (resolved by capability; Graphify's 3.10 is advisory)
  if resolve_python; then
    record_check "python" "OK" "${SDD_PYTHON} ${SDD_PYTHON_VERSION} (resolved)"
    if [[ "$SDD_PYTHON_VERSION" != "(env override)" ]] && ! version_ge "$SDD_PYTHON_VERSION" "3.10.0"; then
      record_check "python-graphify" "WARN" "Python ${SDD_PYTHON_VERSION} meets the kit floor (3.8) but Graphify requires 3.10 — defer Graphify (guide §2.9.4) or upgrade Python"
    fi
  else
    record_check "python" "FAIL" "no usable Python interpreter (tried: python3, python3.14, python3.13, python, py -3, /usr/bin/python3; kit minimum 3.8)"
  fi

  # uv — WARN (bootstrap may install later)
  if command -v uv &>/dev/null; then
    record_check "uv" "OK" "uv $(uv --version 2>/dev/null | head -1)"
  else
    record_check "uv" "WARN" "uv not on PATH — bootstrap may install it later for Graphify"
  fi

  # Build tools for GitNexus — WARN never FAIL; three escape paths required
  local build_ok=true
  local os_name
  os_name="$(uname -s 2>/dev/null || echo unknown)"
  case "$os_name" in
    Linux|GNU*)
      if ! command -v make &>/dev/null || ! command -v g++ &>/dev/null; then
        build_ok=false
      fi
      ;;
    Darwin)
      if ! xcode-select -p &>/dev/null; then
        build_ok=false
      fi
      ;;
    *)
      # Unknown OS: soft WARN if make missing
      if ! command -v make &>/dev/null; then
        build_ok=false
      fi
      ;;
  esac

  if $build_ok; then
    record_check "build-tools" "OK" "GitNexus build tools present"
  else
    local severity_note="Install build tools (python3 make g++ / Xcode CLT)"
    if [[ "$EFFECTIVE_PROFILE" == "APP" || "$EFFECTIVE_PROFILE" == "HYBRID" ]]; then
      severity_note="STRONG WARN (profile ${EFFECTIVE_PROFILE}): code map / impact analysis may be unavailable. Install build tools (python3 make g++ / Xcode CLT)"
    fi
    record_check "build-tools" "WARN" \
      "${severity_note}; or export GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1; or defer GitNexus via C2b §2.9.4"
  fi

  # flock — WARN on Linux (R11 local apply), not hard FAIL for C1
  if [[ "$os_name" == Linux* || "$os_name" == GNU* ]]; then
    if command -v flock &>/dev/null; then
      record_check "flock" "OK" "flock present (session coordination R11)"
    else
      record_check "flock" "WARN" "flock missing — local apply R11 coordination may be limited"
    fi
  else
    record_check "flock" "SKIP" "flock check skipped on ${os_name}"
  fi

  # IDE detection — advisory WARN
  IDE_DETECTED=()
  if command -v cursor &>/dev/null; then IDE_DETECTED+=("cursor"); fi
  if command -v code &>/dev/null; then IDE_DETECTED+=("code"); fi
  if command -v claude &>/dev/null; then IDE_DETECTED+=("claude"); fi
  if [[ -d "${HOME}/.cursor" ]]; then
    local has_cursor=false
    local ide
    for ide in "${IDE_DETECTED[@]+"${IDE_DETECTED[@]}"}"; do
      [[ "$ide" == "cursor" ]] && has_cursor=true
    done
    if ! $has_cursor; then IDE_DETECTED+=("cursor-dir"); fi
  fi
  if [[ -d "${HOME}/.claude" ]]; then
    local has_claude=false
    local ide
    for ide in "${IDE_DETECTED[@]+"${IDE_DETECTED[@]}"}"; do
      [[ "$ide" == "claude" || "$ide" == "claude-dir" ]] && has_claude=true
    done
    if ! $has_claude; then IDE_DETECTED+=("claude-dir"); fi
  fi

  if [[ ${#IDE_DETECTED[@]} -eq 0 ]]; then
    record_check "ide" "WARN" "no IDE detected (cursor/code/claude) — /opsx:* unavailable until Cursor or Claude Code is installed"
  else
    record_check "ide" "OK" "detected: $(IFS=,; echo "${IDE_DETECTED[*]}")"
  fi

  # MCP names advisory (names only from ~/.cursor/mcp.json)
  MCP_NAMES=""
  local mcp_json="${HOME}/.cursor/mcp.json"
  if [[ -r "$mcp_json" ]] && resolve_python; then
    # unquoted by convention: "py -3" is two words
    MCP_NAMES="$($SDD_PYTHON - <<'PY' "$mcp_json"
import json, sys
try:
    with open(sys.argv[1]) as f:
        data = json.load(f)
    servers = data.get("mcpServers") or data.get("servers") or {}
    names = sorted(servers.keys()) if isinstance(servers, dict) else []
    print(", ".join(names) if names else "")
except Exception:
    print("")
PY
)"
    if [[ -z "$MCP_NAMES" ]]; then
      record_check "github-mcp" "WARN" "no MCP servers listed in ~/.cursor/mcp.json (github-mcp advisory — mode D §2.15; never FAIL)"
    elif echo "$MCP_NAMES" | grep -qiE 'github'; then
      record_check "github-mcp" "OK" "MCP names include github* (${MCP_NAMES})"
    else
      record_check "github-mcp" "WARN" "github-mcp not listed in mcp.json (advisory §2.15 fail-open) — names: ${MCP_NAMES}"
    fi
  else
    record_check "github-mcp" "WARN" "~/.cursor/mcp.json not readable — github-mcp advisory only (never FAIL)"
    MCP_NAMES="—"
  fi

  # Optional modules — SKIP when not requested
  record_check "probity-module" "SKIP" "Probity/UI module checks skipped (not requested in phase-0)"
}

check_repo() {
  log_human "==> preflight repo ($REPO_ROOT)"

  if [[ ! -d "$REPO_ROOT/sdd-kit" ]]; then
    # Hub-sourced greenfield mode: a provided --kit-root with a readable sdd-kit/
    # satisfies the kit-presence check; target-local kit always wins when present.
    if [[ -n "$KIT_ROOT" && -d "$KIT_ROOT/sdd-kit" && -r "$KIT_ROOT/sdd-kit" ]]; then
      record_check "sdd-kit" "OK" "sdd-kit/ resolved from source kit root (hub mode): $KIT_ROOT"
    else
      record_check "sdd-kit" "FAIL" "sdd-kit/ missing under repo root — copy kit from hub or run bootstrap from a hub clone"
    fi
  elif [[ ! -r "$REPO_ROOT/sdd-kit" ]]; then
    record_check "sdd-kit" "FAIL" "sdd-kit/ not readable"
  elif [[ ! -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" && ! -f "$REPO_ROOT/sdd-kit/install.sh" ]]; then
    record_check "sdd-kit" "FAIL" "sdd-kit/ present but MANIFEST.yaml/install.sh missing"
  else
    record_check "sdd-kit" "OK" "sdd-kit/ readable"
  fi

  if [[ -w "$REPO_ROOT" ]]; then
    record_check "writable" "OK" "repo root writable"
  else
    record_check "writable" "FAIL" "repo root not writable"
  fi

  # HYBRID is retired as a deprecated alias of APP — package.json + openspec/
  # coexistence is the normal post-install state of every APP repo (no hint).
  record_check "profile-hint" "OK" "profile hint: ${EFFECTIVE_PROFILE}"

  # Runtime the install path executes (scoped: NOT the host scan — install.sh
  # runs preflight in repo mode only and copies templates via this interpreter).
  if resolve_python; then
    record_check "python" "OK" "${SDD_PYTHON} ${SDD_PYTHON_VERSION} (resolved — install runtime)"
  else
    record_check "python" "FAIL" "no usable Python interpreter (tried: python3, python3.14, python3.13, python, py -3, /usr/bin/python3; kit minimum 3.8) — install.sh cannot run"
  fi
}

# --- infra.md Preflight stamp ---
replace_between() {
  local file="$1" marker="$2" value="$3"
  [[ -f "$file" ]] || return
  # Escape sed specials in value minimally
  local escaped
  escaped="$(printf '%s' "$value" | sed -e 's/[&|\\]/\\&/g')"
  # Temp file + mv, never in-place editing: GNU sed takes an optional suffix where
  # BSD/macOS requires one, so no single in-place form is correct on both. No probe needed.
  local _tmp
  _tmp="$(mktemp)"
  sed "s|<!-- ${marker} -->.*<!-- /${marker} -->|<!-- ${marker} -->${escaped}<!-- /${marker} -->|" "$file" > "$_tmp" && mv "$_tmp" "$file"
}

stamp_infra() {
  local mode="${1:-all}"
  local infra="$REPO_ROOT/openspec/infra.md"
  [[ -d "$REPO_ROOT/openspec" ]] || return 0

  if [[ ! -f "$infra" ]]; then
    log_human "INFO: openspec/infra.md absent — skip Preflight stamp (create via install)"
    return 0
  fi

  if ! grep -q '## Preflight (last run)' "$infra"; then
    if [[ -z "$SDD_PYTHON" ]]; then
      log_human "WARN: no usable Python — skipping Preflight section creation in openspec/infra.md"
      return 0
    fi
    # unquoted by convention: "py -3" is two words
    $SDD_PYTHON - "$infra" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
raw = path.read_bytes()
nl = b"\r\n" if b"\r\n" in raw else b"\n"
text = raw.decode("utf-8")
# Work in LF for replacements, re-encode with original nl at end
norm = text.replace("\r\n", "\n")
section = """## Preflight (last run)

> Updated only by `scripts/preflight-sdd.sh` — `verify-infra.sh` must not overwrite this section.

| Field | Value |
|-------|-------|
| Timestamp | <!-- preflight-timestamp -->—<!-- /preflight-timestamp --> |
| IDE(s) | <!-- preflight-ides -->—<!-- /preflight-ides --> |
| WARN summary | <!-- preflight-warns -->—<!-- /preflight-warns --> |
| MCP names (advisory) | <!-- preflight-mcp -->—<!-- /preflight-mcp --> |

"""
if "## SDD Stack" in norm:
    norm = norm.replace("## SDD Stack", section + "## SDD Stack", 1)
else:
    norm = norm.rstrip() + "\n\n" + section
out = norm.encode("utf-8")
if nl == b"\r\n":
    out = norm.replace("\n", "\r\n").encode("utf-8")
path.write_bytes(out)
PY
    log_human "INFO: created ## Preflight (last run) section in openspec/infra.md"
  fi

  local ts ides warns mcp
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%Y-%m-%d)"
  if [[ ${#IDE_DETECTED[@]} -gt 0 ]]; then
    ides="$(IFS=,; echo "${IDE_DETECTED[*]}")"
  else
    ides="none"
  fi
  if [[ ${#WARN_MESSAGES[@]} -gt 0 ]]; then
    warns="$(printf '%s; ' "${WARN_MESSAGES[@]}" | sed 's/; $//')"
    # Keep table cell readable
    warns="${warns//|/\\|}"
    if [[ ${#warns} -gt 200 ]]; then
      warns="${warns:0:197}..."
    fi
  else
    warns="none"
  fi
  mcp="${MCP_NAMES:-—}"
  [[ -n "$mcp" ]] || mcp="—"

  replace_between "$infra" "preflight-timestamp" "$ts"
  replace_between "$infra" "preflight-warns" "$warns"
  # Host-derived markers (IDE/MCP) belong to runs that executed host checks (D5)
  if [[ "$mode" != "repo" ]]; then
    replace_between "$infra" "preflight-ides" "$ides"
    replace_between "$infra" "preflight-mcp" "$mcp"
  fi
  log_human "Updated: openspec/infra.md Preflight stamp ($ts)"
}

emit_json() {
  if [[ -z "$SDD_PYTHON" ]]; then
    log_human "WARN: no usable Python — cannot emit JSON summary"
    return 0
  fi
  # unquoted by convention: "py -3" is two words
  $SDD_PYTHON - <<'PY' "${CHECK_RECORDS[@]}"
import json, sys
records = []
overall = "ok"
for raw in sys.argv[1:]:
    parts = raw.split("|", 2)
    if len(parts) < 3:
        continue
    cid, level, msg = parts
    records.append({"id": cid, "level": level, "message": msg})
    if level == "FAIL":
        overall = "fail"
print(json.dumps({"overall": overall, "checks": records}, ensure_ascii=False, indent=2))
PY
}

# --- main ---
log_human "=== preflight-sdd.sh (mode=$MODE profile=${EFFECTIVE_PROFILE}) ==="

case "$MODE" in
  host) check_host ;;
  repo) check_repo ;;
  all)
    check_host
    check_repo
    ;;
  *)
    echo "ERROR: invalid mode $MODE" >&2
    exit 2
    ;;
esac

# Stamp infra after checks regardless of FAIL so operators see last attempt.
# Mode is passed through: --repo runs never overwrite host-derived markers (IDE/MCP).
stamp_infra "$MODE"

if $JSON; then
  emit_json
fi

log_human ""
log_human "Summary: FAIL=$FAIL_COUNT WARN=$WARN_COUNT SKIP=$SKIP_COUNT"
if [[ "$FAIL_COUNT" -gt 0 ]]; then
  log_human "Preflight FAILED — fix FAIL items before C1 (or use --skip-preflight on bootstrap/install)"
  exit 1
fi
# Machine channel (design D3): a --repo caller (install.sh) captures stdout to
# learn the resolved interpreter — exactly one line, human output is on stderr.
if [[ "$MODE" == "repo" ]] && ! $JSON && [[ -n "$SDD_PYTHON" ]]; then
  echo "SDD_PYTHON=${SDD_PYTHON}"
fi
log_human "Preflight passed (WARN/SKIP allowed)"
exit 0
