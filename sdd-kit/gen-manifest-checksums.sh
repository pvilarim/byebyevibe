#!/usr/bin/env bash
# gen-manifest-checksums.sh — regenerate sha256 fields in sdd-kit/MANIFEST.yaml
# Run this script whenever a file in sdd-kit/templates/ is added or modified, before committing.
# Usage: bash sdd-kit/gen-manifest-checksums.sh [--check]
#
#   --check   Verify checksums without writing (exits 1 if any mismatch or missing)
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$KIT_DIR/MANIFEST.yaml"
CHECK_ONLY=false

usage() {
  cat <<'EOF'
Usage: gen-manifest-checksums.sh [--check]

Regenerates sha256 fields in sdd-kit/MANIFEST.yaml from sdd-kit/templates/.

Options:
  --check     Verify checksums without writing (exits 1 if any mismatch or missing)
  -h, --help  Show this help
EOF
  exit "${1:-0}"
}

for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=true ;;
    -h|--help) usage 0 ;;
    *) echo "ERROR: unknown argument: $arg" >&2; usage 2 ;;
  esac
done

# Detect sha256 utility (Linux coreutils or macOS shasum)
if command -v sha256sum &>/dev/null; then
  SHA256_CMD="sha256sum"
elif command -v shasum &>/dev/null; then
  SHA256_CMD="shasum -a 256"
else
  echo "ERROR: sha256sum/shasum not found — cannot compute checksums" >&2
  exit 1
fi

# Single Python invocation processes the entire MANIFEST (avoids heredoc-in-loop issues)
python3 - "$MANIFEST" "$KIT_DIR" "$SHA256_CMD" "$CHECK_ONLY" << 'PY'
import sys, re, subprocess, os

manifest_path = sys.argv[1]
kit_dir       = sys.argv[2]
sha256_cmd    = sys.argv[3].split()
check_only    = sys.argv[4].lower() in ("true", "1", "yes")

text = open(manifest_path).read()

# Extract all source: values from the manifest
sources = re.findall(r'^\s{4}source:\s+"?([^"\n]+)"?\s*$', text, re.MULTILINE)

errors   = 0
missing  = 0
updated  = 0
warnings = 0

def compute_hash(filepath):
    result = subprocess.run(sha256_cmd + [filepath], capture_output=True, text=True)
    if result.returncode != 0:
        return None
    return result.stdout.split()[0]

new_text = text

for src in sources:
    template_path = os.path.join(kit_dir, src)
    if not os.path.isfile(template_path):
        print(f"MISSING: {src} (template file not found)", file=sys.stderr)
        missing += 1
        continue

    actual_hash = compute_hash(template_path)
    if actual_hash is None:
        print(f"ERROR: could not hash {src}", file=sys.stderr)
        errors += 1
        continue

    if check_only:
        # Find existing sha256 for this source
        m = re.search(
            r'    source:\s*"?' + re.escape(src) + r'"?\n    sha256:\s*"?([a-f0-9]+)"?',
            new_text
        )
        if m:
            existing = m.group(1)
            if existing != actual_hash:
                print(f"FAIL: sha256 mismatch for {src}", file=sys.stderr)
                print(f"  manifest: {existing}", file=sys.stderr)
                print(f"  actual:   {actual_hash}", file=sys.stderr)
                errors += 1
        else:
            print(f"WARN: no sha256 field for {src}", file=sys.stderr)
            warnings += 1
    else:
        # Update or insert sha256 field after source: line
        new_sha_line = f'    sha256: "{actual_hash}"\n'
        pattern = r'(    source:\s*"?' + re.escape(src) + r'"?\n)(    sha256:.*?\n)?'
        replacement = r'\1' + new_sha_line
        new_text, count = re.subn(pattern, replacement, new_text)
        if count == 0:
            print(f"WARN: could not locate source '{src}' in manifest", file=sys.stderr)
            warnings += 1
        else:
            print(f"  sha256 {src} => {actual_hash}")
            updated += 1

if check_only:
    if errors > 0 or missing > 0:
        print(f"\nCHECK FAILED: {errors} mismatch(es), {missing} missing, {warnings} warning(s)", file=sys.stderr)
        sys.exit(1)
    print(f"All checksums OK ({len(sources)} entries, {warnings} warning(s)).")
    sys.exit(0)

if not check_only:
    open(manifest_path, 'w').write(new_text)
    print(f"\nUpdated {updated} sha256 field(s) in {manifest_path}")
    if missing > 0:
        print(f"WARN: {missing} template file(s) not found — those entries were skipped", file=sys.stderr)
        sys.exit(1)
    if warnings > 0:
        print(f"WARN: {warnings} source(s) could not be located in manifest", file=sys.stderr)
    print("\nREMINDER: commit MANIFEST.yaml together with any template changes.")
    print("          Run 'bash sdd-kit/verify.sh' to confirm parity.")
PY
