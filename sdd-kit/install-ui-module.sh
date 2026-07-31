#!/usr/bin/env bash
# SDD UI Development Module — post-C1 add-on (C1-UI)
# Usage: bash sdd-kit/install-ui-module.sh [--detect] [--dry-run] [--apply] [--yes] [--repo PATH]
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$KIT_DIR/templates/doc/design"
DRY_RUN=false
DO_DETECT=false
DO_APPLY=false
AUTO_YES=false
REPO_ROOT="."

usage() {
  cat <<'EOF'
Usage: install-ui-module.sh [--detect] [--dry-run] [--apply] [--yes] [--repo PATH]

Optional UI development module (C1-UI) — runs AFTER core SDD install (C1).
Does NOT modify sdd-kit/install.sh behaviour.

Options:
  --detect    Report frontend presence and UI stack (default if no flags)
  --dry-run   Print planned operations without writing files
  --apply     Copy doc/design/* templates; update infra.md; optional Impeccable
  --yes       Skip shadcn recommendation prompt; allow npx impeccable install
  --repo      Target repository root (default: current directory)
  -h, --help  Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --detect) DO_DETECT=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --apply) DO_APPLY=true; shift ;;
    --yes) AUTO_YES=true; shift ;;
    --repo) REPO_ROOT="${2:-}"; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 2 ;;
  esac
done

if ! $DO_DETECT && ! $DO_APPLY; then
  DO_DETECT=true
fi

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
cd "$REPO_ROOT"

node_major_version() {
  node -v 2>/dev/null | sed 's/^v//' | cut -d. -f1 || echo "0"
}

has_frontend() {
  [[ -f package.json ]] || return 1
  [[ -d app ]] || [[ -d apps/web ]] || [[ -d src/app ]] || return 1
  return 0
}

detect_ui_stack() {
  if grep -qE '@mui/|@chakra-ui/|antd' package.json 2>/dev/null; then
    echo "other"
    return 0
  fi
  if [[ -f components.json ]] || [[ -d components/ui ]]; then
    echo "shadcn"
    return 0
  fi
  if [[ -f tailwind.config.ts ]] || [[ -f tailwind.config.js ]] || [[ -f tailwind.config.mjs ]]; then
    echo "tailwind-custom"
    return 0
  fi
  echo "none"
}

print_detect() {
  if ! has_frontend; then
    echo "SKIP: no frontend (no app/ or apps/web/ with package.json)"
    echo "UI stack: none"
    return 0
  fi

  local stack
  stack="$(detect_ui_stack)"
  echo "Frontend: detected"
  echo "UI stack: $stack"

  case "$stack" in
    shadcn)
      echo "Path: A — see doc/design/001-pipeline-open-design-shadcn-impeccable.md"
      ;;
    tailwind-custom)
      echo "Path: B candidate — shadcn recommended as default; see doc/design/003-ui-stack-adapters.md"
      echo "Run --apply to install docs; use --yes to accept shadcn recommendation or opt-out in project.md"
      ;;
    other)
      echo "Path: C — see doc/design/003-ui-stack-adapters.md"
      ;;
    none)
      echo "Path: undetermined — configure Tailwind or shadcn"
      ;;
  esac
}

copy_design_docs() {
  local files=(000-impeccable-design-system-guia.md 001-pipeline-open-design-shadcn-impeccable.md 002-ui-module-install.md 003-ui-stack-adapters.md)
  for f in "${files[@]}"; do
    local src="$TEMPLATES_DIR/$f"
    local dest="$REPO_ROOT/doc/design/$f"
    if [[ ! -f "$src" ]]; then
      src="$REPO_ROOT/doc/design/$f"
    fi
    if [[ ! -f "$src" ]]; then
      echo "  SKIP missing template: $f"
      continue
    fi
    if $DRY_RUN; then
      echo "  PLAN COPY doc/design/$f"
      continue
    fi
    mkdir -p "$REPO_ROOT/doc/design"
    cp "$src" "$dest"
    echo "  COPY doc/design/$f"
  done
}

update_project_ui_stack() {
  local stack="$1"
  local project="$REPO_ROOT/openspec/project.md"
  [[ -f "$project" ]] || return 0

  if $DRY_RUN; then
    echo "  PLAN update UI stack in openspec/project.md -> $stack"
    return 0
  fi

  if grep -q '^UI stack:' "$project" 2>/dev/null; then
    sed -i "s/^UI stack:.*/UI stack: $stack/" "$project"
  elif grep -q '^## Stack' "$project"; then
  python3 - <<'PY' "$project" "$stack"
import sys, re
path, stack = sys.argv[1], sys.argv[2]
text = open(path).read()
if re.search(r'^UI stack:', text, re.M):
    text = re.sub(r'^UI stack:.*', f'UI stack: {stack}', text, flags=re.M)
else:
    text = re.sub(
        r'(## Stack\n)',
        r'\1\n- **UI stack**: ' + stack + ' (shadcn | tailwind-custom | other | none)\n',
        text,
        count=1,
    )
open(path, 'w').write(text)
PY
  fi
  echo "  UPDATE openspec/project.md UI stack: $stack"
}

update_infra_md() {
  local stack="$1"
  local impeccable_status="${2:-pending}"
  local infra="$REPO_ROOT/openspec/infra.md"
  [[ -f "$infra" ]] || return 0

  if $DRY_RUN; then
    echo "  PLAN update openspec/infra.md UI Development Module section"
    return 0
  fi

  python3 - <<'PY' "$infra" "$stack" "$impeccable_status"
import sys, re
path, stack, impeccable = sys.argv[1:4]
text = open(path).read()
section = f"""## UI Development Module

| Component | Status | Verify with |
|------------|--------|---------------|
| UI stack | {stack} | `grep 'UI stack' openspec/project.md` |
| Impeccable | {impeccable} | `test -d .cursor/skills/impeccable` |
| Open Design | manual / not installed | on demand — see doc/design/002 |
| Pencil | manual / not installed | on demand — see doc/design/002 |
| Figma MCP | manual / not installed | `mcp_get_tools` in session |

"""
marker = "## UI Development Module"
if marker in text:
    text = re.sub(r'## UI Development Module\n.*?(?=\n## |\Z)', section.rstrip() + '\n\n', text, flags=re.S)
else:
    if "## Env vars" in text:
        text = text.replace("## Env vars", section + "## Env vars")
    else:
        text += "\n" + section
open(path, 'w').write(text)
PY
  echo "  UPDATE openspec/infra.md UI Development Module"
}

maybe_install_impeccable() {
  if ! $DO_APPLY; then
    return 0
  fi

  if ! has_frontend; then
    echo "  SKIP Impeccable — no frontend"
    return 0
  fi

  local major
  major="$(node_major_version)"
  if [[ "$major" -lt 24 ]]; then
    echo "  WARN: Node $major < 24 — skipping npx impeccable install (M3 gate)"
    echo "  Install Impeccable manually when Node 24+ is available"
    return 0
  fi

  if ! $AUTO_YES; then
    if [[ ! -t 0 ]]; then
      echo "  SKIP Impeccable — no TTY; use --yes to install"
      return 0
    fi
    read -r -p "Install Impeccable (npx impeccable install)? [y/N] " ans
    case "$ans" in
      [yY]|[yY][eE][sS]) ;;
      *) echo "  SKIP Impeccable — operator declined"; return 0 ;;
    esac
  fi

  if $DRY_RUN; then
    echo "  PLAN npx impeccable install"
    return 0
  fi

  echo "  RUN npx impeccable install"
  npx --yes impeccable install
  echo "  DONE Impeccable installed (.cursor/skills/impeccable)"
}

resolve_stack_for_apply() {
  local detected
  detected="$(detect_ui_stack)"

  if [[ "$detected" == "tailwind-custom" ]] && $AUTO_YES; then
    echo "shadcn"
    return 0
  fi

  if [[ "$detected" == "tailwind-custom" ]] && [[ -t 0 ]] && ! $AUTO_YES; then
    read -r -p "We recommend shadcn/ui as the default path. Install shadcn? [Y/n] " ans
    case "$ans" in
      [nN]|[nN][oO]) echo "tailwind-custom" ;;
      *) echo "shadcn" ;;
    esac
    return 0
  fi

  echo "$detected"
}

run_apply() {
  echo "=== SDD UI Module (C1-UI) ==="
  echo "Repo: $REPO_ROOT"
  $DRY_RUN && echo "Mode: DRY-RUN"
  echo ""

  if ! has_frontend; then
    echo "SKIP: no frontend — copying docs only (reference for DOCS_SPECS hub)"
    copy_design_docs
    update_infra_md "none" "SKIP"
    return 0
  fi

  local stack
  stack="$(resolve_stack_for_apply)"
  echo "Resolved UI stack: $stack"
  echo ""

  copy_design_docs
  update_project_ui_stack "$stack"
  update_infra_md "$stack" "pending"
  maybe_install_impeccable

  if ! $DRY_RUN && $AUTO_YES && [[ "$(node_major_version)" -ge 24 ]]; then
    update_infra_md "$stack" "✅"
  fi

  echo ""
  echo "Done. Next steps:"
  echo "  1. Read doc/design/002-ui-module-install.md"
  echo "  2. npx gitnexus analyze --force (if components/ui/ changed)"
  echo "  3. graphify update ."
}

if $DO_DETECT; then
  print_detect
fi

if $DO_APPLY; then
  run_apply
fi

exit 0
