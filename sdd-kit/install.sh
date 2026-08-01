#!/usr/bin/env bash
# ByeByeVibe (sdd-kit) — greenfield install (C1)
# Usage: bash sdd-kit/install.sh --profile APP|DOCS_SPECS|HYBRID [--dry-run] [--repo PATH]
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$KIT_DIR/MANIFEST.yaml"

# _sha256 <file> — returns lowercase hex sha256 digest, or empty string if unavailable
_sha256() {
  if command -v sha256sum &>/dev/null; then
    sha256sum "$1" 2>/dev/null | cut -d' ' -f1
  elif command -v shasum &>/dev/null; then
    shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1
  else
    echo "WARN: sha256sum/shasum not available — integrity check skipped for $1" >&2
    echo ""
  fi
}
PROFILE=""
DRY_RUN=false
REPO_ROOT="."
CHAT_LANG=""
DOCS_LANG=""
CODE_LANG=""
LANG_FLAGS_PROVIDED=false

validate_locale() {
  local value="$1" label="$2"
  case "$value" in
    en|pt-BR) return 0 ;;
    *)
      echo "ERROR: invalid $label: '$value' (allowed: en, pt-BR)" >&2
      exit 1
      ;;
  esac
}

prompt_locale() {
  local label="$1" default="en"
  local choice
  echo ""
  echo "$label (1=en, 2=pt-BR) [default: $default]:"
  read -r choice
  case "${choice:-}" in
    ""|1) echo "en" ;;
    2) echo "pt-BR" ;;
    en|pt-BR) echo "$choice" ;;
    *)
      echo "ERROR: invalid choice: '$choice' (allowed: en, pt-BR)" >&2
      exit 1
      ;;
  esac
}

resolve_language_policy() {
  if [[ -z "$CHAT_LANG" ]]; then
    if [[ -t 0 ]]; then
      CHAT_LANG="$(prompt_locale "chat_language")"
    else
      CHAT_LANG="en"
    fi
  fi
  if [[ -z "$DOCS_LANG" ]]; then
    if [[ -t 0 ]]; then
      DOCS_LANG="$(prompt_locale "docs_language")"
    else
      DOCS_LANG="en"
    fi
  fi
  if [[ -z "$CODE_LANG" ]]; then
    if [[ -t 0 ]]; then
      CODE_LANG="$(prompt_locale "code_language")"
    else
      CODE_LANG="en"
    fi
  fi

  validate_locale "$CHAT_LANG" "chat_language"
  validate_locale "$DOCS_LANG" "docs_language"
  validate_locale "$CODE_LANG" "code_language"

  if ! $LANG_FLAGS_PROVIDED && [[ "$CHAT_LANG" == "en" && "$DOCS_LANG" == "en" && "$CODE_LANG" == "en" ]]; then
    echo "Using language defaults: chat=en docs=en code=en"
  fi

  echo "Language policy: chat=$CHAT_LANG docs=$DOCS_LANG code=$CODE_LANG"
}

substitute_language_placeholders() {
  local file="$1"
  sed -e "s/{{CHAT_LANG}}/$CHAT_LANG/g" \
      -e "s/{{DOCS_LANG}}/$DOCS_LANG/g" \
      -e "s/{{CODE_LANG}}/$CODE_LANG/g" \
      "$file"
}

inject_language_policy() {
  local project_md="$REPO_ROOT/openspec/project.md"
  if $DRY_RUN; then
    echo "  PLAN [LANGUAGE_POLICY] openspec/project.md (chat=$CHAT_LANG docs=$DOCS_LANG code=$CODE_LANG)"
    return 0
  fi
  if [[ ! -f "$project_md" ]]; then
    echo "  WARN openspec/project.md missing — add Language policy after openspec init"
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  python3 - "$project_md" "$tmp" "$CHAT_LANG" "$DOCS_LANG" "$CODE_LANG" <<'PY'
import re, sys
path, out, chat, docs, code = sys.argv[1:6]
text = open(path).read()
block = f"""## Language policy

<!-- SDD_LANGUAGE_POLICY_START -->
| Axis | Key | Value |
|------|-----|-------|
| Chat | `chat_language` | {chat} |
| Docs | `docs_language` | {docs} |
| Code | `code_language` | {code} |
<!-- SDD_LANGUAGE_POLICY_END -->

Configured at C1 install (`sdd-kit/install.sh`). v1 allowlist: `en`, `pt-BR`. See guide §2.1.1.
"""
inner = block.split("<!-- SDD_LANGUAGE_POLICY_START -->", 1)[1].split("<!-- SDD_LANGUAGE_POLICY_END -->", 1)[0].strip()
pattern = r"<!-- SDD_LANGUAGE_POLICY_START -->.*?<!-- SDD_LANGUAGE_POLICY_END -->"
if re.search(pattern, text, re.DOTALL):
    text = re.sub(
        pattern,
        f"<!-- SDD_LANGUAGE_POLICY_START -->\n{inner}\n<!-- SDD_LANGUAGE_POLICY_END -->",
        text,
        count=1,
        flags=re.DOTALL,
    )
elif re.search(r"^## Language policy", text, re.MULTILINE):
    text = re.sub(r"^## Language policy.*?(?=^## |\Z)", block + "\n", text, count=1, flags=re.MULTILINE | re.DOTALL)
elif re.search(r"^## Constraints", text, re.MULTILINE):
    text = re.sub(r"^## Constraints", block + "\n\n## Constraints", text, count=1, flags=re.MULTILINE)
else:
    text = text.rstrip() + "\n\n" + block + "\n"
open(out, "w").write(text)
PY
  mv "$tmp" "$project_md"
  echo "  UPDATE openspec/project.md Language policy"
}

usage() {
  cat <<'EOF'
Usage: install.sh --profile APP|DOCS_SPECS|HYBRID [--dry-run] [--repo PATH]
       [--chat-lang en|pt-BR] [--docs-lang en|pt-BR] [--code-lang en|pt-BR]

Copies curated SDD files from sdd-kit/templates/ into the target repository.
Does NOT run openspec init or install global CLIs — use scripts/bootstrap-sdd.sh first.

Options:
  --profile     Required. APP, DOCS_SPECS, or HYBRID
  --dry-run     Print planned operations without writing files
  --repo        Target repository root (default: current directory)
  --chat-lang   Chat language: en or pt-BR (default: en)
  --docs-lang   Documentation language: en or pt-BR (default: en)
  --code-lang   Code prose language: en or pt-BR (default: en)
  -h, --help    Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --repo) REPO_ROOT="${2:-}"; shift 2 ;;
    --chat-lang) CHAT_LANG="${2:-}"; LANG_FLAGS_PROVIDED=true; shift 2 ;;
    --docs-lang) DOCS_LANG="${2:-}"; LANG_FLAGS_PROVIDED=true; shift 2 ;;
    --code-lang) CODE_LANG="${2:-}"; LANG_FLAGS_PROVIDED=true; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 2 ;;
  esac
done

[[ -n "$PROFILE" ]] || { echo "ERROR: --profile is required" >&2; usage 2; }
[[ -f "$MANIFEST" ]] || { echo "ERROR: MANIFEST not found: $MANIFEST" >&2; exit 1; }

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
cd "$REPO_ROOT"

apply_file() {
  local src="$1" dest="$2" merge="$3" sha256="${4:-}"
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

  # Integrity check: verify sha256 of template before copying (D3 policy)
  if [[ -n "$sha256" ]]; then
    local actual
    actual="$(_sha256 "$src_path")"
    if [[ -n "$actual" && "$sha256" != "$actual" ]]; then
      echo "ERROR: integrity check failed: $src (expected $sha256, got $actual)" >&2
      exit 1
    fi
  else
    echo "WARN: no sha256 for $src — skipping integrity check" >&2
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

  local tmp merged
  tmp="$(mktemp)"
  merged="$(mktemp)"
  awk '
    /<!-- SDD_KIT_COMMANDS_START -->/ { print; while ((getline line < cmd) > 0) print line; close(cmd); skip=1; next }
    /<!-- SDD_KIT_COMMANDS_END -->/ { skip=0; print; next }
    skip==0 { print }
  ' cmd="$commands_file" "$core" > "$tmp"
  substitute_language_placeholders "$tmp" > "$merged"
  mv "$merged" "$dest_path"
  rm -f "$tmp"
  echo "  NEW  AGENTS.md (core + $PROFILE commands)"
}

echo "=== ByeByeVibe (sdd-kit) v$(grep -E '^version:' "$MANIFEST" | head -1 | sed 's/.*"\(.*\)".*/\1/') ==="
echo "Profile: $PROFILE"
echo "Repo:    $REPO_ROOT"
$DRY_RUN && echo "Mode:    DRY-RUN"
if [[ "$PROFILE" == "DOCS_SPECS" ]]; then
  echo "SKIP Renovate: profile DOCS_SPECS"
fi
echo ""

resolve_language_policy
echo ""

while IFS=$'\t' read -r src dest merge sha256; do
  [[ -n "$src" ]] || continue
  apply_file "$src" "$dest" "$merge" "$sha256"
  if [[ "$dest" == *.sh ]]; then
    chmod +x "$REPO_ROOT/$dest" 2>/dev/null || true
  fi
done < <(python3 - "$MANIFEST" "$PROFILE" << 'PY'
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
            elif key == "sha256":
                block["sha256"] = val.strip('"')
if block and "path" in block:
    entries.append(block)
for e in entries:
    profiles = e.get("profiles", ["APP", "DOCS_SPECS", "HYBRID"])
    if profile not in profiles:
        continue
    print(f"{e['source']}\t{e['path']}\t{e.get('merge','COPY')}\t{e.get('sha256','')}")
PY
)

inject_language_policy

print_day1_operate_tip() {
  # Day-1 operate reminder (pointers only — NEVER invokes help/onboard here)
  echo ""
  if $DRY_RUN; then
    if [[ "$CHAT_LANG" == "pt-BR" ]]; then
      echo "PLAN — Operar no dia 1: /opsx:help (mapa deste control plane) e depois /opsx:onboard (praticar um ciclo completo — OpenSpec upstream)."
    else
      echo "PLAN — Day-1 operate: /opsx:help (map this control plane) then /opsx:onboard (practice a full cycle — upstream OpenSpec)."
    fi
    return 0
  fi
  if [[ "$CHAT_LANG" == "pt-BR" ]]; then
    echo "Operar no dia 1: /opsx:help (mapa deste control plane) e depois /opsx:onboard (praticar um ciclo completo — OpenSpec upstream)."
  else
    echo "Day-1 operate: /opsx:help (map this control plane) then /opsx:onboard (practice a full cycle — upstream OpenSpec)."
  fi
}

print_optional_addons_teaser() {
  # Optional entry points (pointers only — NEVER invoked here):
  #   install-ui-module.sh · install-probity-module.sh · sdd-metrics.sh · guide §2.12
  echo ""
  if $DRY_RUN; then
    if [[ "$CHAT_LANG" == "pt-BR" ]]; then
      echo "PLAN — Complementos opcionais (somente lembrete; NÃO instalados neste dry-run):"
      echo "  · UI (C1-UI)     → guia §2.11 · sdd-kit/install-ui-module"
      echo "  · Probity (G2)   → guia §2.16 · sdd-kit/install-probity-module"
      echo "  · CI gates       → guia §2.12 · proteção de branch (manual)"
      echo "  · Métricas (G4)  → guia §2.17 · scripts/sdd-metrics"
      echo "  (ponteiros apenas — rode depois do checklist §2.8 se fizer sentido)"
    else
      echo "PLAN — Optional add-ons (informational only; NOT installed in this dry-run):"
      echo "  · UI (C1-UI)     → guide §2.11 · sdd-kit/install-ui-module"
      echo "  · Probity (G2)   → guide §2.16 · sdd-kit/install-probity-module"
      echo "  · CI gates       → guide §2.12 · branch protection (manual)"
      echo "  · Metrics (G4)   → guide §2.17 · scripts/sdd-metrics"
      echo "  (pointers only — run after checklist §2.8 if they fit)"
    fi
    return 0
  fi
  if [[ "$CHAT_LANG" == "pt-BR" ]]; then
    echo "Complementos opcionais (ponteiros apenas — não instalados agora):"
    echo "  · UI (C1-UI)     → guia §2.11 · sdd-kit/install-ui-module"
    echo "  · Probity (G2)   → guia §2.16 · sdd-kit/install-probity-module"
    echo "  · CI gates       → guia §2.12 · proteção de branch (manual)"
    echo "  · Métricas (G4)  → guia §2.17 · scripts/sdd-metrics"
    echo "  Rode depois do checklist §2.8 se fizer sentido. Sem menu; sem auto-install."
  else
    echo "Optional add-ons (pointers only — not installed now):"
    echo "  · UI (C1-UI)     → guide §2.11 · sdd-kit/install-ui-module"
    echo "  · Probity (G2)   → guide §2.16 · sdd-kit/install-probity-module"
    echo "  · CI gates       → guide §2.12 · branch protection (manual)"
    echo "  · Metrics (G4)   → guide §2.17 · scripts/sdd-metrics"
    echo "  Run after checklist §2.8 if they fit. No menu; no auto-install."
  fi
}

echo ""
echo "Done. Next steps:"
echo "  1. Edit openspec/project.md (Purpose, Stack — do not replace with template)"
echo "  2. Merge AGENTS.md if it already existed"
echo "  3. bash sdd-kit/verify.sh"
echo "  4. Checklist doc/sistema-sdd-pedro.md §2.8"
print_day1_operate_tip
print_optional_addons_teaser
