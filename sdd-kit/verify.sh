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

# Kit integrity parity check (hub only — skipped in consumer repos without templates/)
if [[ -d "$REPO_ROOT/sdd-kit/templates" ]] && [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  echo ""
  echo "==> kit-integrity (hub only)"

  if ! command -v sha256sum &>/dev/null && ! command -v shasum &>/dev/null; then
    echo "WARN: sha256sum/shasum not available — kit-integrity check skipped"
  else
    KIT_INTEGRITY_RESULT="$(python3 - "$REPO_ROOT/sdd-kit/MANIFEST.yaml" "$REPO_ROOT/sdd-kit" << 'PY'
import sys, re, subprocess, os

manifest_path = sys.argv[1]
kit_dir       = sys.argv[2]
text = open(manifest_path).read()

import shutil
if shutil.which("sha256sum"):
    sha256_cmd = ["sha256sum"]
elif shutil.which("shasum"):
    sha256_cmd = ["shasum", "-a", "256"]
else:
    print("SKIP: no sha256 utility")
    sys.exit(0)

sources = re.findall(r"^\s{4}source:\s+\"?([^\"'\n]+)\"?\s*$", text, re.MULTILINE)

errors   = 0
warnings = 0

for src in sources:
    template_path = os.path.join(kit_dir, src)
    # Find sha256 for this source in MANIFEST
    m = re.search(
        r"    source:\s*\"?" + re.escape(src) + r"\"?\n    sha256:\s*\"?([a-f0-9]+)\"?",
        text
    )
    if not m:
        print(f"WARN: no sha256 field for {src}")
        warnings += 1
        continue

    expected = m.group(1)

    if not os.path.isfile(template_path):
        print(f"FAIL: template not found: {src}")
        errors += 1
        continue

    result = subprocess.run(sha256_cmd + [template_path], capture_output=True, text=True)
    actual = result.stdout.split()[0] if result.returncode == 0 else ""

    if not actual:
        print(f"WARN: could not hash {src}")
        warnings += 1
    elif actual != expected:
        print(f"FAIL: sha256 mismatch: {src}")
        print(f"  expected: {expected}")
        print(f"  actual:   {actual}")
        errors += 1

print(f"entries={len(sources)} errors={errors} warnings={warnings}")
sys.exit(errors)
PY
    )" || true

    if echo "$KIT_INTEGRITY_RESULT" | grep -q "^FAIL:"; then
      echo "$KIT_INTEGRITY_RESULT"
      echo "FAIL: kit-integrity" >&2
      ((FAILURES++)) || true
    elif echo "$KIT_INTEGRITY_RESULT" | grep -q "^WARN:"; then
      echo "$KIT_INTEGRITY_RESULT"
      echo "OK: kit-integrity (with warnings)"
    else
      echo "$KIT_INTEGRITY_RESULT"
      echo "OK: kit-integrity"
    fi
  fi
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

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: sdd-kit verification passed ✅"
  exit 0
else
  echo "Summary: $FAILURES check(s) failed ❌"
  exit 1
fi
