#!/usr/bin/env bash
# SDD Install Kit — post-install verification orchestration
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FAILURES=0

run_check() {
  local label="$1"
  shift
  echo ""
  echo "==> $label"
  if "$@"; then
    echo "OK: $label"
  else
    echo "FAIL: $label" >&2
    ((FAILURES++)) || true
  fi
}

echo "=== sdd-kit/verify.sh ==="
echo "Repo: $REPO_ROOT"

if [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  KIT_VER="$(grep -E '^version:' "$REPO_ROOT/sdd-kit/MANIFEST.yaml" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo '?')"
  echo "Kit version: $KIT_VER"
else
  echo "WARN: sdd-kit/MANIFEST.yaml not found in repo"
fi

if [[ -x "$REPO_ROOT/scripts/verify-infra.sh" ]]; then
  run_check "verify-infra.sh" bash "$REPO_ROOT/scripts/verify-infra.sh" || true
else
  echo "FAIL: scripts/verify-infra.sh missing" >&2
  ((FAILURES++)) || true
fi

if [[ -x "$REPO_ROOT/scripts/verify-task-patterns.sh" ]]; then
  run_check "verify-task-patterns.sh" bash "$REPO_ROOT/scripts/verify-task-patterns.sh" || true
fi

if [[ -x "$REPO_ROOT/scripts/sdd-session-status.sh" ]]; then
  run_check "sdd-session-status.sh" bash "$REPO_ROOT/scripts/sdd-session-status.sh" || true
else
  echo "FAIL: scripts/sdd-session-status.sh missing" >&2
  ((FAILURES++)) || true
fi

# CI gates (G1): workflow instalado + template no hub (add-sdd-ci-gates-workflow)
run_check "sdd-gates workflow" test -f "$REPO_ROOT/.github/workflows/sdd-gates.yml"
if [[ -d "$REPO_ROOT/sdd-kit/templates" ]]; then
  run_check "sdd-gates template" test -f "$REPO_ROOT/sdd-kit/templates/.github/workflows/sdd-gates.yml"
fi

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: sdd-kit verification passed ✅"
  exit 0
else
  echo "Summary: $FAILURES check(s) failed ❌"
  exit 1
fi
