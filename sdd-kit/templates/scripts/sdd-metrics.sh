#!/usr/bin/env bash
# sdd-metrics.sh — relatório de eficácia SDD (G4), modo C (sob demanda)
# Fontes: git + openspec/changes/ + openspec/changes/archive/
# Sem rede, sem tokens, sem DevLake. Ver doc/byebyevibe-guide.md §2.17
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SINCE=""
OUTPUT=""
CHECK_CADENCE=0
GENERATED_ON="$(date +%Y-%m-%d)"

# Cadence defaults (documented in §2.17) — not env-configurable in this change
CADENCE_N=5
CADENCE_T=30
STAMP_FILE="$REPO_ROOT/.sdd/metrics-last-run"
CHANGES_DIR="$REPO_ROOT/openspec/changes"
ARCHIVE_DIR="$CHANGES_DIR/archive"

usage() {
  cat <<'EOF'
Usage: bash scripts/sdd-metrics.sh [--since YYYY-MM-DD] [--output PATH] [--check-cadence] [--help]

On-demand (mode C) markdown report of SDD framework effectiveness metrics.
Depends only on bash + git. Does NOT require Apache DevLake.

Flags:
  --since YYYY-MM-DD   Include archives with directory date >= this date
  --output PATH        Also write the same markdown report to PATH
  --check-cadence      Advisory only: exit 0 if fresh, exit 1 if nudge due
                       (defaults N=5 archives since last run, T=30 days).
                       Does NOT generate the full report.
  --help               Show this help and exit 0

Metrics (proxies — see report notes):
  M1 Volume            Active changes vs archived changes
  M2 Lead time         First commit mentioning change-id → archive date (days)
  M3 Rework            fix: commits after archive that mention change-id (R9)
  M4 Post-archive      Summary of corrective activity (M3 as primary proxy)

Stamp: successful report (exit 0) writes .sdd/metrics-last-run (YYYY-MM-DD).
Playbook: doc/byebyevibe-guide.md §2.17

Exit codes: 0 = report generated / cadence fresh; 1 = cadence nudge due;
            2 = invalid usage
EOF
}

die_usage() {
  echo "ERROR: $*" >&2
  usage >&2
  exit 2
}

is_iso_date() {
  local d="$1"
  [[ "$d" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || return 1
  date -d "$d" +%Y-%m-%d >/dev/null 2>&1
}

date_to_epoch() {
  date -d "$1" +%s
}

days_between() {
  # days from date A to date B (B - A), floored
  local a="$1" b="$2"
  echo $(( ( $(date_to_epoch "$b") - $(date_to_epoch "$a") ) / 86400 ))
}

write_stamp() {
  mkdir -p "$(dirname "$STAMP_FILE")"
  {
    echo "$GENERATED_ON"
    date -Iseconds 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ"
  } >"$STAMP_FILE"
}

read_stamp_date() {
  # prints YYYY-MM-DD from first line, or empty if missing/invalid
  if [[ ! -f "$STAMP_FILE" ]]; then
    return 1
  fi
  local line
  line="$(head -1 "$STAMP_FILE" | tr -d '[:space:]')"
  if is_iso_date "$line"; then
    echo "$line"
    return 0
  fi
  return 1
}

# Count archive dirs whose YYYY-MM-DD prefix is strictly after $1 (exclusive)
count_archives_after() {
  local after="$1"
  local count=0
  local dirname adate
  if [[ ! -d "$ARCHIVE_DIR" ]]; then
    echo 0
    return 0
  fi
  shopt -s nullglob
  for d in "$ARCHIVE_DIR"/*/; do
    dirname="$(basename "$d")"
    if [[ "$dirname" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})-(.+)$ ]]; then
      adate="${BASH_REMATCH[1]}"
      if (( $(date_to_epoch "$adate") > $(date_to_epoch "$after") )); then
        count=$((count + 1))
      fi
    fi
  done
  shopt -u nullglob
  echo "$count"
}

# Count archive dirs with date >= $1 (inclusive)
count_archives_on_or_after() {
  local since="$1"
  local count=0
  local dirname adate
  if [[ ! -d "$ARCHIVE_DIR" ]]; then
    echo 0
    return 0
  fi
  shopt -s nullglob
  for d in "$ARCHIVE_DIR"/*/; do
    dirname="$(basename "$d")"
    if [[ "$dirname" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})-(.+)$ ]]; then
      adate="${BASH_REMATCH[1]}"
      if (( $(date_to_epoch "$adate") >= $(date_to_epoch "$since") )); then
        count=$((count + 1))
      fi
    fi
  done
  shopt -u nullglob
  echo "$count"
}

emit_nudge() {
  local reason="$1"
  cat <<EOF
SDD metrics cadence nudge ($reason).
Run: bash scripts/sdd-metrics.sh
Then interpret with the playbook in doc/byebyevibe-guide.md §2.17 (1 insight → 1 adjustment).
EOF
}

check_cadence() {
  local today stamp_date archives_since age cutoff recent
  today="$(date +%Y-%m-%d)"

  if stamp_date="$(read_stamp_date)"; then
    archives_since="$(count_archives_after "$stamp_date")"
    age="$(days_between "$stamp_date" "$today")"
    if (( archives_since >= CADENCE_N )); then
      emit_nudge "≥${CADENCE_N} archives since last run (${archives_since} after ${stamp_date})"
      return 1
    fi
    if (( age >= CADENCE_T )); then
      emit_nudge "stamp age ≥${CADENCE_T} days (${age}d since ${stamp_date})"
      return 1
    fi
    return 0
  fi

  # No stamp — onboarding: nudge if ≥1 archive in last T days
  cutoff="$(date -d "${today} - ${CADENCE_T} days" +%Y-%m-%d)"
  recent="$(count_archives_on_or_after "$cutoff")"
  if (( recent >= 1 )); then
    emit_nudge "no stamp yet — baseline recommended (≥1 archive in last ${CADENCE_T}d)"
    return 1
  fi
  return 0
}

# Parse CLI
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --since)
      [[ $# -ge 2 ]] || die_usage "--since requires YYYY-MM-DD"
      SINCE="$2"
      is_iso_date "$SINCE" || die_usage "invalid --since date: $SINCE (expected YYYY-MM-DD)"
      shift 2
      ;;
    --output)
      [[ $# -ge 2 ]] || die_usage "--output requires PATH"
      OUTPUT="$2"
      shift 2
      ;;
    --check-cadence)
      CHECK_CADENCE=1
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      die_usage "unknown flag: $1"
      ;;
    *)
      die_usage "unexpected argument: $1"
      ;;
  esac
done
[[ $# -eq 0 ]] || die_usage "unexpected argument: $1"

if [[ "$CHECK_CADENCE" -eq 1 ]]; then
  if [[ -n "$SINCE" || -n "$OUTPUT" ]]; then
    die_usage "--check-cadence cannot be combined with --since or --output"
  fi
  if check_cadence; then
    exit 0
  else
    exit 1
  fi
fi

# --- Collect active changes (M1) ---
ACTIVE_IDS=()
if [[ -d "$CHANGES_DIR" ]]; then
  shopt -s nullglob
  for d in "$CHANGES_DIR"/*/; do
    name="$(basename "$d")"
    case "$name" in
      archive|_template|.*) continue ;;
    esac
    ACTIVE_IDS+=("$name")
  done
  shopt -u nullglob
fi

# --- Collect archives: ARCHIVE_DATE|CHANGE_ID|DIRNAME ---
# shellcheck disable=SC2034
ARCHIVE_ROWS=()
ARCHIVE_WARN=0
if [[ -d "$ARCHIVE_DIR" ]]; then
  shopt -s nullglob
  for d in "$ARCHIVE_DIR"/*/; do
    dirname="$(basename "$d")"
    if [[ "$dirname" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})-(.+)$ ]]; then
      adate="${BASH_REMATCH[1]}"
      cid="${BASH_REMATCH[2]}"
      if [[ -n "$SINCE" ]]; then
        if (( $(date_to_epoch "$adate") < $(date_to_epoch "$SINCE") )); then
          continue
        fi
      fi
      ARCHIVE_ROWS+=("${adate}|${cid}|${dirname}")
    else
      ARCHIVE_WARN=$((ARCHIVE_WARN + 1))
      echo "WARN: skipping archive dir without YYYY-MM-DD- prefix: $dirname" >&2
    fi
  done
  shopt -u nullglob
fi

# Sort archives by date then id
IFS=$'\n' ARCHIVE_SORTED=($(printf '%s\n' "${ARCHIVE_ROWS[@]:-}" | LC_ALL=C sort))
unset IFS

# --- Helpers for git lookups ---
first_commit_date_for_change() {
  local cid="$1"
  local d
  # Prefer earliest commit whose subject/body mentions change-id
  d="$(git log --all --reverse --format='%ad' --date=short --grep="$cid" -i 2>/dev/null | head -1 || true)"
  if [[ -n "$d" ]]; then
    echo "$d"
    return 0
  fi
  # Fallback: first commit that added proposal.md (active path or any archive rename)
  d="$(git log --all --reverse --format='%ad' --date=short --diff-filter=A -- \
    "openspec/changes/${cid}/proposal.md" \
    2>/dev/null | head -1 || true)"
  if [[ -n "$d" ]]; then
    echo "$d"
    return 0
  fi
  # Last resort: any historical path ending in /<cid>/proposal.md via --follow-like name search
  d="$(git log --all --reverse --format='%ad' --date=short --diff-filter=A -- \
    "**/openspec/changes/**/${cid}/proposal.md" \
    "**/archive/*-${cid}/proposal.md" \
    2>/dev/null | head -1 || true)"
  if [[ -n "$d" ]]; then
    echo "$d"
    return 0
  fi
  return 1
}

count_rework_commits() {
  local cid="$1"
  local after_date="$2" # exclusive lower bound via --after (git --after is exclusive of that day start... use day before? )
  # git log --after=DATE includes commits after that date (not including DATE 00:00).
  # Archive date is t_end; we want commits strictly after archive day → --after=archive_date
  local count
  count="$(git log --all --after="$after_date" --format='%s' 2>/dev/null \
    | grep -E '^(fix(\([^)]*\))?:|fix!(\([^)]*\))?:)' \
    | grep -F "$cid" \
    | wc -l \
    | tr -d ' ')"
  echo "${count:-0}"
}

# --- Build report into temp, then emit ---
REPORT_TMP="$(mktemp)"
trap 'rm -f "$REPORT_TMP"' EXIT

{
  echo "# SDD Metrics Report"
  echo ""
  echo "- Generated: ${GENERATED_ON}"
  echo "- Repo: \`${REPO_ROOT}\`"
  if [[ -n "$SINCE" ]]; then
    echo "- Filter: \`--since ${SINCE}\`"
  else
    echo "- Filter: (none — all archives)"
  fi
  echo "- Mode: C (on-demand) — not a CI gate; Apache DevLake out of scope"
  echo ""
  echo "> **Proxy honesty:** M2 uses first commit mentioning change-id (or first add of proposal.md) as propose proxy — real propose may be earlier (chat-only) or later (id only at archive). M3 depends on Conventional Commits + R9 change-id discipline; commits without change-id are undercounted."
  echo ""

  # M1
  echo "## M1 — Volume"
  echo ""
  echo "| Category | Count |"
  echo "|----------|------:|"
  echo "| Active changes (\`openspec/changes/<id>/\`) | ${#ACTIVE_IDS[@]} |"
  echo "| Archived changes (in period) | ${#ARCHIVE_SORTED[@]} |"
  if [[ "$ARCHIVE_WARN" -gt 0 ]]; then
    echo "| Skipped (bad archive name) | ${ARCHIVE_WARN} |"
  fi
  echo ""
  if [[ ${#ACTIVE_IDS[@]} -gt 0 ]]; then
    echo "Active change-ids:"
    for id in $(printf '%s\n' "${ACTIVE_IDS[@]}" | LC_ALL=C sort); do
      echo "- \`${id}\`"
    done
    echo ""
  fi
  if [[ ${#ARCHIVE_SORTED[@]} -eq 0 ]]; then
    echo "_Zero archived changes in scope._"
    echo ""
  fi

  # M2 + M3 collection
  echo "## M2 — Lead time propose→archive"
  echo ""
  echo "| Archive date | Change-id | t_start | Lead (days) |"
  echo "|--------------|-----------|---------|------------:|"

  LEAD_SUM=0
  LEAD_N=0
  LEAD_VALUES=()
  REWORK_TOTAL=0
  declare -a REWORK_LINES=()

  for row in "${ARCHIVE_SORTED[@]:-}"; do
    [[ -z "$row" ]] && continue
    IFS='|' read -r adate cid dirname <<<"$row"
    t_start=""
    lead="n/a"
    if t_start="$(first_commit_date_for_change "$cid")"; then
      start_e="$(date_to_epoch "$t_start")"
      end_e="$(date_to_epoch "$adate")"
      lead=$(( (end_e - start_e) / 86400 ))
      # Clamp negative (clock/order quirks) to 0
      if [[ "$lead" -lt 0 ]]; then
        lead=0
      fi
      LEAD_SUM=$((LEAD_SUM + lead))
      LEAD_N=$((LEAD_N + 1))
      LEAD_VALUES+=("$lead")
    else
      t_start="n/a"
    fi
    echo "| ${adate} | \`${cid}\` | ${t_start} | ${lead} |"

    rework="$(count_rework_commits "$cid" "$adate")"
    REWORK_TOTAL=$((REWORK_TOTAL + rework))
    REWORK_LINES+=("| \`${cid}\` | ${adate} | ${rework} |")
  done

  if [[ ${#ARCHIVE_SORTED[@]} -eq 0 ]]; then
    echo "| — | — | — | — |"
  fi
  echo ""

  if [[ "$LEAD_N" -gt 0 ]]; then
    mean="$(awk -v s="$LEAD_SUM" -v n="$LEAD_N" 'BEGIN { printf "%.1f", s/n }')"
    # median
    IFS=$'\n' sorted_leads=($(printf '%s\n' "${LEAD_VALUES[@]}" | LC_ALL=C sort -n))
    unset IFS
    mid=$((LEAD_N / 2))
    if (( LEAD_N % 2 == 1 )); then
      median="${sorted_leads[$mid]}"
    else
      a="${sorted_leads[$((mid - 1))]}"
      b="${sorted_leads[$mid]}"
      median="$(awk -v a="$a" -v b="$b" 'BEGIN { printf "%.1f", (a+b)/2 }')"
    fi
    echo "**Summary:** n=${LEAD_N} · mean=${mean} days · median (p50)=${median} days"
  else
    echo "**Summary:** n=0 — no lead times computed (empty archive or no git anchors)."
  fi
  echo ""

  # M3
  echo "## M3 — Rework pós-archive (\`fix\` + change-id)"
  echo ""
  echo "| Change-id | Archive date | Rework commits |"
  echo "|-----------|--------------|---------------:|"
  if [[ ${#REWORK_LINES[@]} -eq 0 ]]; then
    echo "| — | — | 0 |"
  else
    for line in "${REWORK_LINES[@]}"; do
      echo "$line"
    done
  fi
  echo ""
  echo "**Total rework commits (M3):** ${REWORK_TOTAL}"
  echo ""
  echo "_Depends on R9 (change-id in commit messages). Subjects matching \`^fix(\|:)\` after archive date._"
  echo ""

  # M4
  echo "## M4 — Actividade pós-archive"
  echo ""
  echo "Primary proxy = M3 (fix commits referencing archived change-ids after archive date)."
  echo ""
  if [[ "$REWORK_TOTAL" -eq 0 ]]; then
    echo "- No post-archive \`fix\` commits with change-id detected in scope."
  else
    echo "- ${REWORK_TOTAL} post-archive \`fix\` commit(s) touch archived change-ids (see M3)."
  fi
  echo "- Changes with rework > 0 may indicate incomplete archive or follow-up corrections."
  echo ""

  echo "## Notes"
  echo ""
  echo "- Archive \`t_end\` is the \`YYYY-MM-DD\` prefix of \`openspec/changes/archive/YYYY-MM-DD-<id>/\`."
  echo "- Active changes appear only in M1 (lead time requires a completed archive)."
  echo "- This script is mode **C** (on-demand). It is not part of \`sdd-gates\` CI."
  echo "- Apache DevLake remains out of scope; re-evaluate only if team/DORA scale justifies it."
  echo "- After a successful run, \`.sdd/metrics-last-run\` is updated for cadence checks (\`--check-cadence\`)."
} >"$REPORT_TMP"

cat "$REPORT_TMP"
if [[ -n "$OUTPUT" ]]; then
  # Ensure parent dir exists when possible
  out_dir="$(dirname "$OUTPUT")"
  if [[ "$out_dir" != "." && ! -d "$out_dir" ]]; then
    mkdir -p "$out_dir"
  fi
  cp "$REPORT_TMP" "$OUTPUT"
fi

write_stamp
exit 0
