#!/usr/bin/env bash
# SDD Probity Module (G2) — post-C1 add-on for APP/HYBRID with tests
# Usage: bash sdd-kit/install-probity-module.sh [--detect] [--dry-run] [--apply] [--yes] [--uninstall] [--repo PATH]
# Pin: @nizos/probity@1.10.0
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$KIT_DIR/templates"
PROBITY_PIN="@nizos/probity@1.10.0"
DRY_RUN=false
DO_DETECT=false
DO_APPLY=false
DO_UNINSTALL=false
AUTO_YES=false
REPO_ROOT="."

usage() {
  cat <<'EOF'
Usage: install-probity-module.sh [--detect] [--dry-run] [--apply] [--yes] [--uninstall] [--repo PATH]

Optional Probity (G2) module — runs AFTER core SDD install (C1).
Materialises R6 via enforceTdd() PreToolUse hook. Does NOT modify install.sh.

Options:
  --detect     Report test runner presence and Probity applicability (default if no flags)
  --dry-run    Print planned operations without writing files
  --apply      Copy probity.config.ts; npm install -D @nizos/probity@1.10.0; update infra.md
  --yes        Skip interactive npm install prompt on apply
  --uninstall  Remove probity.config.ts, documented hook notes, and @nizos/probity when present
  --repo PATH  Target repository root (default: current directory)
  -h, --help   Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --detect) DO_DETECT=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --apply) DO_APPLY=true; shift ;;
    --yes) AUTO_YES=true; shift ;;
    --uninstall) DO_UNINSTALL=true; shift ;;
    --repo) REPO_ROOT="${2:-}"; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 2 ;;
  esac
done

if ! $DO_DETECT && ! $DO_APPLY && ! $DO_UNINSTALL; then
  DO_DETECT=true
fi

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
cd "$REPO_ROOT"

has_c1_core() {
  [[ -f AGENTS.md ]] && [[ -f openspec/infra.md ]]
}

detect_test_runner() {
  local runner="none"

  if [[ -f package.json ]]; then
    if grep -qE '"vitest"|vitest' package.json 2>/dev/null; then
      runner="vitest"
    elif grep -qE '"jest"|jest' package.json 2>/dev/null; then
      runner="jest"
    fi
  fi

  if [[ "$runner" == "none" ]]; then
    if [[ -f pytest.ini ]] || [[ -f pyproject.toml ]] || [[ -f setup.cfg ]]; then
      if grep -qE 'pytest' pytest.ini pyproject.toml setup.cfg 2>/dev/null; then
        runner="pytest"
      fi
    fi
    if [[ "$runner" == "none" ]] && [[ -d tests ]] && command -v pytest &>/dev/null; then
      runner="pytest"
    fi
    if [[ "$runner" == "none" ]] && [[ -f requirements.txt ]] && grep -qi 'pytest' requirements.txt 2>/dev/null; then
      runner="pytest"
    fi
  fi

  echo "$runner"
}

is_docs_specs_without_tests() {
  local runner
  runner="$(detect_test_runner)"
  [[ "$runner" == "none" ]] && [[ ! -d app ]] && [[ ! -d src ]] && [[ ! -d components ]]
}

print_detect() {
  local runner
  runner="$(detect_test_runner)"

  if ! has_c1_core; then
    echo "WARN: C1 core missing (need AGENTS.md + openspec/infra.md)"
  fi

  if [[ "$runner" == "none" ]]; then
    echo "SKIP: no test runner"
    echo "Test runner: none"
    echo "Probity: not applicable (install Vitest, Jest, or pytest first)"
    return 0
  fi

  echo "Test runner: $runner"
  echo "Probity: applicable"
  echo "Pin: $PROBITY_PIN"
  echo "Config: probity.config.ts (enforceTdd + forbidCommandPattern)"
  if [[ -f probity.config.ts ]]; then
    echo "Status: config present"
  else
    echo "Status: config missing — run --apply"
  fi
}

resolve_config_template() {
  local src="$TEMPLATES_DIR/probity.config.ts"
  if [[ -f "$src" ]]; then
    echo "$src"
    return 0
  fi
  src="$KIT_DIR/templates/probity.config.ts"
  if [[ -f "$src" ]]; then
    echo "$src"
    return 0
  fi
  # Hub layout: script lives in sdd-kit/, templates sibling
  src="$(cd "$KIT_DIR/.." 2>/dev/null && pwd)/sdd-kit/templates/probity.config.ts"
  if [[ -f "$src" ]]; then
    echo "$src"
    return 0
  fi
  return 1
}

copy_config() {
  local src
  if ! src="$(resolve_config_template)"; then
    echo "ERROR: probity.config.ts template not found under sdd-kit/templates/" >&2
    return 1
  fi
  local dest="$REPO_ROOT/probity.config.ts"
  if $DRY_RUN; then
    echo "  PLAN COPY probity.config.ts <- $src"
    return 0
  fi
  cp "$src" "$dest"
  echo "  COPY probity.config.ts"
}

copy_install_doc() {
  local files=(004-probity-module-install.md)
  local design_tmpl="$TEMPLATES_DIR/doc/design"
  for f in "${files[@]}"; do
    local src="$design_tmpl/$f"
    local dest="$REPO_ROOT/doc/design/$f"
    if [[ ! -f "$src" ]]; then
      src="$REPO_ROOT/doc/design/$f"
    fi
    if [[ ! -f "$src" ]]; then
      # try hub kit layout when script is sdd-kit/install-probity-module.sh
      src="$(cd "$KIT_DIR" && pwd)/templates/doc/design/$f"
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

update_infra_md() {
  local status="${1:-SKIP}"
  local infra="$REPO_ROOT/openspec/infra.md"
  [[ -f "$infra" ]] || return 0

  if $DRY_RUN; then
    echo "  PLAN update openspec/infra.md Probity Module section ($status)"
    return 0
  fi

  python3 - <<'PY' "$infra" "$status"
import sys, re
path, status = sys.argv[1:3]
text = open(path).read()
section = f"""## Probity Module

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| `@nizos/probity@1.10.0` | {status} | `test -f probity.config.ts` |
| `probity.config.ts` | {status} | `grep -q enforceTdd probity.config.ts` |
| Plugin / hook | {status} | Claude Code: `/plugin install probity@probity` |

Módulo opcional G2 (APP/HYBRID com testes). DOCS_SPECS sem test runner: SKIP.
Operação: `doc/sistema-sdd-pedro.md` §2.16 · `doc/design/004-probity-module-install.md`.

"""
marker = "## Probity Module"
if marker in text:
    text = re.sub(r'## Probity Module\n.*?(?=\n## |\Z)', section.rstrip() + '\n\n', text, flags=re.S)
else:
    if "## Env vars" in text:
        text = text.replace("## Env vars", section + "## Env vars")
    else:
        text += "\n" + section
open(path, 'w').write(text)
PY
  echo "  UPDATE openspec/infra.md Probity Module ($status)"
}

npm_install_probity() {
  if [[ ! -f package.json ]]; then
    echo "  WARN: no package.json — skip npm install; add $PROBITY_PIN manually if needed"
    return 0
  fi

  if ! $AUTO_YES; then
    if [[ ! -t 0 ]]; then
      echo "  SKIP npm install — no TTY; use --yes to install $PROBITY_PIN"
      return 0
    fi
    read -r -p "Install $PROBITY_PIN as devDependency? [y/N] " ans
    case "$ans" in
      [yY]|[yY][eE][sS]) ;;
      *) echo "  SKIP npm install — operator declined"; return 0 ;;
    esac
  fi

  if $DRY_RUN; then
    echo "  PLAN npm install -D $PROBITY_PIN"
    return 0
  fi

  echo "  RUN npm install -D $PROBITY_PIN"
  npm install -D "$PROBITY_PIN"
}

run_apply() {
  echo "=== SDD Probity Module (G2) ==="
  echo "Repo: $REPO_ROOT"
  $DRY_RUN && echo "Mode: DRY-RUN"
  echo ""

  if ! has_c1_core; then
    echo "ERROR: C1 core SDD required first (AGENTS.md + openspec/infra.md missing)" >&2
    echo "Run bash sdd-kit/install.sh --profile APP|HYBRID before this module." >&2
    exit 1
  fi

  local runner
  runner="$(detect_test_runner)"
  if [[ "$runner" == "none" ]]; then
    echo "SKIP: no test runner — Probity not applicable on this repo"
    copy_install_doc
    update_infra_md "SKIP — no test runner"
    return 0
  fi

  echo "Test runner: $runner"
  echo ""
  copy_config
  copy_install_doc
  npm_install_probity

  local status="✅"
  if [[ ! -f "$REPO_ROOT/probity.config.ts" ]] && ! $DRY_RUN; then
    status="pending"
  fi
  if $DRY_RUN; then
    status="pending (dry-run)"
  fi
  update_infra_md "$status"

  echo ""
  echo "Done. Next steps:"
  echo "  1. /plugin marketplace add nizos/probity"
  echo "  2. /plugin install probity@probity"
  echo "  3. Restart Claude Code session"
  echo "  4. Read doc/design/004-probity-module-install.md"
  echo "  5. Pilot: measure PreToolUse p95 with GitNexus + Graphify + Probity"
}

run_uninstall() {
  echo "=== SDD Probity Module — uninstall ==="
  echo "Repo: $REPO_ROOT"
  $DRY_RUN && echo "Mode: DRY-RUN"
  echo ""

  if $DRY_RUN; then
    [[ -f probity.config.ts ]] && echo "  PLAN rm probity.config.ts"
    [[ -f package.json ]] && grep -q '@nizos/probity' package.json 2>/dev/null && echo "  PLAN npm uninstall @nizos/probity"
    echo "  PLAN revert openspec/infra.md Probity Module section"
    echo "  PLAN manual: /plugin uninstall probity@probity"
    return 0
  fi

  if [[ -f probity.config.ts ]]; then
    rm -f probity.config.ts
    echo "  REMOVED probity.config.ts"
  fi

  if [[ -f package.json ]] && grep -q '@nizos/probity' package.json 2>/dev/null; then
    npm uninstall @nizos/probity || echo "  WARN: npm uninstall failed — remove manually"
  fi

  # Mark infra as uninstalled rather than deleting whole file sections blindly
  update_infra_md "uninstalled"

  echo ""
  echo "Done. Also run: /plugin uninstall probity@probity"
  echo "Remove any Cursor/Claude hook entries that invoke Probity."
}

if $DO_DETECT; then
  print_detect
fi

if $DO_UNINSTALL; then
  run_uninstall
fi

if $DO_APPLY; then
  run_apply
fi

exit 0
