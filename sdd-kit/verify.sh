#!/usr/bin/env bash
# ByeByeVibe (sdd-kit) — post-install verification orchestration
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

KIT_VER=""
GUIDE_VER=""
if [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  KIT_VER="$(grep -E '^version:' "$REPO_ROOT/sdd-kit/MANIFEST.yaml" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo '?')"
  GUIDE_VER="$(grep -E '^guide_version:' "$REPO_ROOT/sdd-kit/MANIFEST.yaml" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo '?')"
  echo "Kit version: $KIT_VER"
  echo "Guide version: $GUIDE_VER"
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

# Task 3.1 — session check is meaningless in CI runners (ephemeral, no .sdd/runtime/)
if [[ -z "${CI:-}" ]]; then
  if [[ -x "$REPO_ROOT/scripts/sdd-session-status.sh" ]]; then
    run_check "sdd-session-status.sh" bash "$REPO_ROOT/scripts/sdd-session-status.sh" || true
  else
    echo "FAIL: scripts/sdd-session-status.sh missing" >&2
    ((FAILURES++)) || true
  fi
else
  echo ""
  echo "==> sdd-session-status.sh"
  echo "INFO: session check skipped in CI (CI=${CI})"
fi

# CI gates (G1): workflow instalado + template no hub (add-sdd-ci-gates-workflow)
run_check "sdd-gates workflow" test -f "$REPO_ROOT/.github/workflows/sdd-gates.yml"
if [[ -d "$REPO_ROOT/sdd-kit/templates" ]]; then
  run_check "sdd-gates template" test -f "$REPO_ROOT/sdd-kit/templates/.github/workflows/sdd-gates.yml"
fi

# Probity module (G2) — report-only when module not installed (hub DOCS_SPECS = SKIP)
echo ""
echo "==> Probity module (G2)"
if [[ -x "$REPO_ROOT/sdd-kit/install-probity-module.sh" ]]; then
  echo "OK: install-probity-module.sh present"
  if [[ -f "$REPO_ROOT/probity.config.ts" ]]; then
    if grep -q 'enforceTdd' "$REPO_ROOT/probity.config.ts"; then
      echo "OK: probity.config.ts with enforceTdd"
    else
      echo "WARN: probity.config.ts missing enforceTdd" >&2
    fi
  else
    echo "INFO: Probity not installed in this repo (report-only — expected on DOCS_SPECS)"
  fi
elif [[ -f "$REPO_ROOT/sdd-kit/templates/install-probity-module.sh" ]]; then
  echo "OK: Probity template present in kit (module script not copied to this profile)"
else
  echo "INFO: Probity module artifacts absent (report-only)"
fi

# SDD metrics (G4) — on-demand mode C; presence check only (not a CI gate)
echo ""
echo "==> sdd-metrics.sh (G4)"
if [[ -x "$REPO_ROOT/scripts/sdd-metrics.sh" ]]; then
  echo "OK: scripts/sdd-metrics.sh present"
elif [[ -f "$REPO_ROOT/sdd-kit/templates/scripts/sdd-metrics.sh" ]]; then
  echo "OK: sdd-metrics template present in kit (not yet copied to scripts/)"
else
  echo "INFO: sdd-metrics.sh absent (report-only)"
fi

# Release readiness (add-release-readiness-gate, issue #348): version-sync,
# kit-integrity, and hub scripts<->templates parity now live in their own
# script with an independent exit code, so a dedicated CI step can block on
# them without inheriting verify-infra.sh's environment-dependent FAILs.
if [[ -x "$REPO_ROOT/scripts/verify-release-readiness.sh" ]]; then
  run_check "verify-release-readiness.sh" bash "$REPO_ROOT/scripts/verify-release-readiness.sh" || true
else
  echo "FAIL: scripts/verify-release-readiness.sh missing" >&2
  ((FAILURES++)) || true
fi

# Language policy (sdd-language-policy) — consumer installs
echo ""
echo "==> language policy"
if [[ -f "$REPO_ROOT/AGENTS.md" ]]; then
  if grep -q '{{CHAT_LANG}}\|{{DOCS_LANG}}\|{{CODE_LANG}}' "$REPO_ROOT/AGENTS.md"; then
    echo "FAIL: AGENTS.md contains unreplaced language placeholders" >&2
    ((FAILURES++)) || true
  else
    echo "OK: AGENTS.md language placeholders substituted"
  fi
else
  echo "INFO: AGENTS.md not present — language placeholder check skipped"
fi

if [[ -f "$REPO_ROOT/openspec/project.md" ]]; then
  if [[ -d "$REPO_ROOT/sdd-kit/templates" ]]; then
    echo "INFO: hub distribution repo — Language policy in project.md skipped (grandfathered per sdd-language-policy)"
  elif grep -q '## Language policy' "$REPO_ROOT/openspec/project.md" \
     && grep -q 'chat_language\|docs_language\|code_language' "$REPO_ROOT/openspec/project.md"; then
    echo "OK: openspec/project.md Language policy present"
  else
    echo "WARN: openspec/project.md missing Language policy section (add after install — see guide §2.1.1)" >&2
  fi
fi

# Soft WARN: phase-0 Preflight never stamped (non-blocking — do not increment FAILURES)
echo ""
echo "==> preflight stamp (soft)"
INFRA_MD="$REPO_ROOT/openspec/infra.md"
if [[ -f "$INFRA_MD" ]] && grep -q 'preflight-timestamp' "$INFRA_MD"; then
  PF_TS="$(sed -n 's/.*<!-- preflight-timestamp -->\(.*\)<!-- \/preflight-timestamp -->.*/\1/p' "$INFRA_MD" | head -1)"
  if [[ -z "$PF_TS" || "$PF_TS" == "—" || "$PF_TS" == "-" ]]; then
    echo "WARN: Preflight timestamp is still a placeholder — run bash scripts/preflight-sdd.sh --all (non-blocking)" >&2
  else
    echo "OK: Preflight stamped ($PF_TS)"
  fi
elif [[ -f "$INFRA_MD" ]]; then
  echo "WARN: openspec/infra.md missing Preflight markers — run bash scripts/preflight-sdd.sh --all (non-blocking)" >&2
else
  echo "INFO: openspec/infra.md absent — preflight soft check skipped"
fi

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: sdd-kit verification passed ✅"
  exit 0
else
  echo "Summary: $FAILURES check(s) failed ❌"
  exit 1
fi
