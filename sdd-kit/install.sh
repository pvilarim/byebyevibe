#!/usr/bin/env bash
# SDD Install Kit — greenfield install (C1)
# Usage: bash sdd-kit/install.sh --profile APP|DOCS_SPECS|HYBRID [--dry-run] [--repo PATH]
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$KIT_DIR/MANIFEST.yaml"
PROFILE=""
DRY_RUN=false
REPO_ROOT="."

usage() {
  cat <<'EOF'
Usage: install.sh --profile APP|DOCS_SPECS|HYBRID [--dry-run] [--repo PATH]

Copies curated SDD files from sdd-kit/templates/ into the target repository.
Does NOT run openspec init or install global CLIs — use scripts/bootstrap-sdd.sh first.

Options:
  --profile   Required. APP, DOCS_SPECS, or HYBRID
  --dry-run   Print planned operations without writing files
  --repo      Target repository root (default: current directory)
  -h, --help  Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --repo) REPO_ROOT="${2:-}"; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 2 ;;
  esac
done

[[ -n "$PROFILE" ]] || { echo "ERROR: --profile is required" >&2; usage 2; }
[[ -f "$MANIFEST" ]] || { echo "ERROR: MANIFEST not found: $MANIFEST" >&2; exit 1; }

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
cd "$REPO_ROOT"

apply_file() {
  local src="$1" dest="$2" merge="$3"
  local src_path="$KIT_DIR/$src"
  local dest_path
  dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
  [[ "$dest_path" == "$REPO_ROOT"/* ]] || {
    echo "ERROR: path traversal blocked: $dest" >&2
    exit 1
  }

  if [[ ! -f "$src_path" ]]; then
    echo "  SKIP missing source: $src"
    return 0
  fi

  # Task 4.1 — warn when installing GitHub Actions workflows in non-GitHub CI environments
  if [[ "$dest" == .github/workflows/* ]]; then
    if [[ -n "${GITLAB_CI:-}" || -n "${GITEA_ACTIONS:-}" || -n "${TF_BUILD:-}" || -n "${CIRCLECI:-}" ]]; then
      echo "WARN: Installing '$dest' in a non-GitHub CI environment." \
           "The workflow uses GitHub Actions syntax and will need adaptation for your CI platform." >&2
    fi
  fi

  if $DRY_RUN; then
    echo "  PLAN [$merge] $dest <- $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest_path")"
  case "$merge" in
    COPY)
      cp "$src_path" "$dest_path"
      echo "  COPY $dest"
      ;;
    MERGE)
      if [[ ! -f "$dest_path" ]]; then
        cp "$src_path" "$dest_path"
        echo "  NEW  $dest"
      else
        echo "  KEEP $dest (MERGE — manual review if template changed)"
      fi
      ;;
    MERGE_PROFILE)
      merge_agents_profile "$dest_path"
      ;;
    *)
      cp "$src_path" "$dest_path"
      echo "  COPY $dest"
      ;;
  esac

  if [[ "$dest" == scripts/*.sh || "$dest" == */*.sh ]]; then
    chmod +x "$dest_path" 2>/dev/null || true
  fi
  if [[ "$dest" == *.sh ]]; then
    chmod +x "$dest_path" 2>/dev/null || true
  fi
}

merge_agents_profile() {
  local dest_path="$1"
  local core="$KIT_DIR/templates/AGENTS.core.md"
  local commands_file=""

  case "$PROFILE" in
    APP) commands_file="$KIT_DIR/templates/AGENTS.commands.APP.md" ;;
    DOCS_SPECS) commands_file="$KIT_DIR/templates/AGENTS.commands.DOCS_SPECS.md" ;;
    HYBRID)
      commands_file="$KIT_DIR/templates/AGENTS.commands.APP.md"
      ;;
  esac

  if $DRY_RUN; then
    echo "  PLAN [MERGE_PROFILE] AGENTS.md <- AGENTS.core.md + $(basename "$commands_file")"
    return 0
  fi

  if [[ -f "$dest_path" ]]; then
    echo "  KEEP AGENTS.md (exists — merge manually or delete for fresh install)"
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  awk '
    /<!-- SDD_KIT_COMMANDS_START -->/ { print; while ((getline line < cmd) > 0) print line; close(cmd); skip=1; next }
    /<!-- SDD_KIT_COMMANDS_END -->/ { skip=0; print; next }
    skip==0 { print }
  ' cmd="$commands_file" "$core" > "$tmp"
  mv "$tmp" "$dest_path"
  echo "  NEW  AGENTS.md (core + $PROFILE commands)"
}

echo "=== SDD Install Kit v$(grep -E '^version:' "$MANIFEST" | head -1 | sed 's/.*"\(.*\)".*/\1/') ==="
echo "Profile: $PROFILE"
echo "Repo:    $REPO_ROOT"
$DRY_RUN && echo "Mode:    DRY-RUN"
echo ""

while IFS=$'\t' read -r src dest merge; do
  [[ -n "$src" ]] || continue
  apply_file "$src" "$dest" "$merge"
  if [[ "$dest" == *.sh ]]; then
    chmod +x "$REPO_ROOT/$dest" 2>/dev/null || true
  fi
done < <(python3 - <<'PY' "$MANIFEST" "$PROFILE"
import sys, re
manifest_path, profile = sys.argv[1:3]
text = open(manifest_path).read()
entries = []
block = None
for line in text.splitlines():
    if line.strip().startswith("- path:"):
        if block and "path" in block:
            entries.append(block)
        block = {"path": line.split(":", 1)[1].strip()}
    elif block is not None:
        m = re.match(r"\s+(\w+):\s*(.+)", line)
        if m:
            key, val = m.group(1), m.group(2).strip()
            if key == "profiles":
                block["profiles"] = re.findall(r"\w+", val)
            elif key in ("path", "source", "merge"):
                block[key] = val.strip('"')
if block and "path" in block:
    entries.append(block)
for e in entries:
    profiles = e.get("profiles", ["APP", "DOCS_SPECS", "HYBRID"])
    if profile not in profiles:
        continue
    print(f"{e['source']}\t{e['path']}\t{e.get('merge','COPY')}")
PY
)

echo ""
echo "Done. Next steps:"
echo "  1. Edit openspec/project.md (Purpose, Stack — do not replace with template)"
echo "  2. Merge AGENTS.md if it already existed"
echo "  3. bash sdd-kit/verify.sh"
echo "  4. Checklist doc/sistema-sdd-pedro.md §2.8"
