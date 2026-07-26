#!/usr/bin/env bash
# SDD Install Kit — upgrade diff and apply (C2)
# Usage: bash sdd-kit/upgrade.sh --from X.Y.Z --to X.Y.Z [--profile APP|DOCS_SPECS|HYBRID] [--dry-run] [--apply] [--repo PATH] [--force]
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$KIT_DIR/MANIFEST.yaml"
FROM_VER=""
TO_VER=""
DRY_RUN=false
APPLY=false
REPO_ROOT="."
PROFILE=""
FORCE=false

usage() {
  cat <<'EOF'
Usage: upgrade.sh --from VERSION --to VERSION [--profile APP|DOCS_SPECS|HYBRID] [--dry-run] [--apply] [--repo PATH] [--force]

Classifies manifest files vs target repo. Default is dry-run report only.
Use --apply only after human approval of UPGRADE_REPORT.md.

Options:
  --from      Current guide/kit version
  --to        Target version (must match MANIFEST.yaml)
  --profile   Profile filter: APP, DOCS_SPECS, or HYBRID.
              Required when --apply is used. Optional for dry-run (shows all with [all-profiles] label).
  --dry-run   Produce diff report (default if --apply omitted)
  --apply     Apply COPY files (never auto-merges AGENTS.md or project.md).
              Requires --profile. Blocked on main/master branch unless --force is passed.
  --force     Bypass branch safety check (allow --apply directly on main/master)
  --repo      Target repository root
  -h, --help  Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from) FROM_VER="${2:-}"; shift 2 ;;
    --to) TO_VER="${2:-}"; shift 2 ;;
    --profile) PROFILE="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --apply) APPLY=true; shift ;;
    --force) FORCE=true; shift ;;
    --repo) REPO_ROOT="${2:-}"; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 2 ;;
  esac
done

[[ -n "$FROM_VER" && -n "$TO_VER" ]] || { echo "ERROR: --from and --to are required" >&2; usage 2; }
if $DRY_RUN && $APPLY; then
  echo "ERROR: --dry-run e --apply são mutuamente exclusivos" >&2
  exit 2
fi

# Task 1.3 — --apply requires --profile
if $APPLY && [[ -z "$PROFILE" ]]; then
  echo "ERROR: --apply requires --profile APP|DOCS_SPECS|HYBRID" >&2
  echo "       Supply the profile that matches this repository (e.g. --profile DOCS_SPECS)" >&2
  exit 2
fi

$APPLY || DRY_RUN=true

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
cd "$REPO_ROOT"

MANIFEST_VER="$(grep -E '^version:' "$MANIFEST" | head -1 | sed 's/.*"\(.*\)".*/\1/')"
if [[ "$TO_VER" != "$MANIFEST_VER" ]]; then
  echo "WARN: --to ($TO_VER) differs from MANIFEST ($MANIFEST_VER)" >&2
fi

$DRY_RUN && echo "=== SDD UPGRADE REPORT (dry-run) ===" || echo "=== SDD UPGRADE APPLY ==="
echo "From: v$FROM_VER  To: v$TO_VER"
echo "Repo: $REPO_ROOT"
[[ -n "$PROFILE" ]] && echo "Profile: $PROFILE" || echo "Profile: (all — supply --profile to filter)"
echo ""

classify() {
  local dest="$1" merge="$2" src="$KIT_DIR/$3" label="${4:-}"
  local prefix=""
  [[ -n "$label" ]] && prefix="[$label] "
  if [[ ! -f "$REPO_ROOT/$dest" ]]; then
    echo "NEW          ${prefix}$dest"
    return
  fi
  if [[ ! -f "$src" ]]; then
    echo "SKIP         ${prefix}$dest (no template)"
    return
  fi
  if diff -q "$REPO_ROOT/$dest" "$src" &>/dev/null; then
    echo "KEEP_LOCAL   ${prefix}$dest (identical to template)"
    return
  fi
  case "$merge" in
    MERGE|MERGE_PROFILE) echo "MERGE        ${prefix}$dest" ;;
    COPY) echo "COPY           ${prefix}$dest" ;;
    *) echo "MERGE        ${prefix}$dest" ;;
  esac
}

# Task 1.2 — dry-run Python block: extract profiles and filter (or show all with [all-profiles])
echo "--- File classification ---"
while IFS=$'\t' read -r src dest merge label; do
  [[ -n "$dest" ]] || continue
  classify "$dest" "$merge" "$src" "$label"
done < <(python3 - <<'PY' "$MANIFEST" "$PROFILE"
import sys, re
manifest_path = sys.argv[1]
profile = sys.argv[2] if len(sys.argv) > 2 else ""
text = open(manifest_path).read()
entries, block = [], None
for line in text.splitlines():
    if line.strip().startswith("- path:"):
        if block and "path" in block: entries.append(block)
        block = {"path": line.split(":",1)[1].strip()}
    elif block is not None:
        m = re.match(r"\s+(\w+):\s*(.+)", line)
        if m:
            k, v = m.group(1), m.group(2).strip().strip('"')
            if k == "profiles":
                block["profiles"] = re.findall(r"\w+", v)
            elif k in ("source", "merge", "path"):
                block[k] = v
if block and "path" in block: entries.append(block)
for e in entries:
    entry_profiles = e.get("profiles", ["APP", "DOCS_SPECS", "HYBRID"])
    if profile:
        if profile not in entry_profiles:
            continue
        label = ""
    else:
        label = "all-profiles"
    print(f"{e.get('source','')}\t{e['path']}\t{e.get('merge','COPY')}\t{label}")
PY
)

REPORT_DIR="$REPO_ROOT/openspec/changes/upgrade-sdd-v${TO_VER}"
REPORT_FILE="$REPORT_DIR/UPGRADE_REPORT.md"

if $DRY_RUN && ! $APPLY; then
  echo ""
  echo "Scaffold: $REPORT_FILE"
  if [[ ! -f "$REPORT_FILE" ]]; then
    mkdir -p "$REPORT_DIR"
    cat > "$REPORT_FILE" <<EOF
# Relatório de actualização SDD

| Campo | Valor |
|-------|--------|
| Repositório | $(basename "$REPO_ROOT") |
| Versão guia (antes) | v$FROM_VER |
| Versão guia (alvo) | v$TO_VER |
| Data | $(date +%Y-%m-%d) |

## Resumo executivo

- [ ] Actualização aprovada pelo utilizador

## Matriz de ficheiros

Ver output de \`bash sdd-kit/upgrade.sh --from $FROM_VER --to $TO_VER --dry-run\`

Classificações: KEEP_LOCAL · MERGE · COPY · NEW · SKIP

## Aprovação

- [ ] Humano aprovou merge de AGENTS.md e openspec/project.md
EOF
    echo "Created UPGRADE_REPORT scaffold."
  else
    echo "UPGRADE_REPORT already exists — not overwriting."
  fi
  echo ""
  echo "PARAR: revisar relatório antes de --apply"
  exit 0
fi

if $APPLY; then
  # Task 2.2 — block apply on main/master without --force
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
  if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    if ! $FORCE; then
      echo "ERROR: You are on branch '$CURRENT_BRANCH'. Applying SDD upgrades directly on main/master is unsafe." >&2
      echo "       Create an isolation branch first: git checkout -b chore/upgrade-sdd-v${TO_VER}" >&2
      echo "       Or bypass with --force if you know what you are doing." >&2
      exit 1
    else
      echo "WARN: --force supplied — applying directly on '$CURRENT_BRANCH'" >&2
    fi
  fi

  if [[ ! -f "$REPORT_FILE" ]]; then
    echo "ERROR: UPGRADE_REPORT não encontrado: $REPORT_FILE" >&2
    echo "       Correr primeiro: bash sdd-kit/upgrade.sh --from $FROM_VER --to $TO_VER --dry-run" >&2
    exit 1
  fi
  if ! grep -q '\[x\] Actualização aprovada' "$REPORT_FILE"; then
    echo "ERROR: UPGRADE_REPORT existe mas não foi aprovado." >&2
    echo "       Marcar '- [x] Actualização aprovada' em $REPORT_FILE antes de --apply" >&2
    exit 1
  fi
  echo ""
  echo "--- Applying COPY files only (profile: $PROFILE) ---"

  # Task 1.4 — apply Python block: filter by profiles
  while IFS=$'\t' read -r src dest merge; do
    [[ -n "$dest" ]] || continue
    [[ "$merge" == "COPY" ]] || continue
    [[ -f "$KIT_DIR/$src" ]] || continue
    dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
    [[ "$dest_path" == "$REPO_ROOT"/* ]] || {
      echo "ERROR: path traversal blocked: $dest" >&2
      exit 1
    }
    if [[ -f "$REPO_ROOT/$dest" ]] && ! diff -q "$KIT_DIR/$src" "$REPO_ROOT/$dest" &>/dev/null; then
      cp "$REPO_ROOT/$dest" "$REPO_ROOT/$dest.bak.$(date +%s)"
      echo "  BACKUP $dest"
    fi
    mkdir -p "$(dirname "$REPO_ROOT/$dest")"
    cp "$KIT_DIR/$src" "$REPO_ROOT/$dest"
    [[ "$dest" == *.sh ]] && chmod +x "$REPO_ROOT/$dest"
    echo "  APPLIED $dest"
  done < <(python3 - <<'PY' "$MANIFEST" "$PROFILE"
import sys, re
manifest_path = sys.argv[1]
profile = sys.argv[2]
text = open(manifest_path).read()
entries, block = [], None
for line in text.splitlines():
    if line.strip().startswith("- path:"):
        if block and "path" in block: entries.append(block)
        block = {"path": line.split(":",1)[1].strip()}
    elif block is not None:
        m = re.match(r"\s+(\w+):\s*(.+)", line)
        if m:
            k, v = m.group(1), m.group(2).strip().strip('"')
            if k == "profiles":
                block["profiles"] = re.findall(r"\w+", v)
            elif k in ("source", "merge", "path"):
                block[k] = v
if block and "path" in block: entries.append(block)
for e in entries:
    entry_profiles = e.get("profiles", ["APP", "DOCS_SPECS", "HYBRID"])
    if profile not in entry_profiles:
        continue
    if e.get("merge") == "COPY":
        print(f"{e.get('source','')}\t{e['path']}\t{e.get('merge','COPY')}")
PY
)
  echo "Apply complete. Run: bash sdd-kit/verify.sh"
fi
