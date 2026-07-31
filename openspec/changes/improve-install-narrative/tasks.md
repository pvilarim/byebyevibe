## 1. Guide §2 didactic narrative

- [ ] 1.1 Enrich §2.1 with three-pillars (+ kit) diagram, S-layer why-order, and link to §4 (do not rewrite §4)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -nE '2\.1|pillar|§4|section 4' doc/sistema-sdd-pedro.md | head -20 | grep -qiE 'pillar|OpenSpec|GitNexus|Graphify'`

- [ ] 1.2 Add What / Why now / Without it / You’ll get to §2.2 OpenSpec using design D3 EN copy
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'Without it' doc/sistema-sdd-pedro.md && grep -A2 '### 2.2' doc/sistema-sdd-pedro.md | head -1; grep -q 'nobody remembers why\|chat turns into code' doc/sistema-sdd-pedro.md`

- [ ] 1.3 Add What / Why now / Without it / You’ll get to §2.3 GitNexus using design D3 EN copy
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'edits by vibe\|breaks the neighborhood' doc/sistema-sdd-pedro.md`

- [ ] 1.4 Add What / Why now / Without it / You’ll get to §2.4 Graphify using design D3 EN copy
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'reinvents what the team already wrote' doc/sistema-sdd-pedro.md`

- [ ] 1.5 Insert **Optional add-ons at a glance** immediately after §2.8 (UI, Probity, CI, Metrics pointers only; no menu)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `awk '/### 2\.8/,/### 2\.11/' doc/sistema-sdd-pedro.md | grep -q 'Optional add-ons'`

## 2. Agent prompt §2.0 and discovery README

- [ ] 2.1 Update §2.0 install prompt: agent explains S before each step; T on demand / when next action needs commands; T→S
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `awk '/### 2\.0 AI-assisted/,/### 2\.2/' doc/sistema-sdd-pedro.md | grep -qiE 'simple|S layer|before each|on demand'`

- [ ] 2.2 Add one README paragraph “How the three tools fit” linking to guide §2.1
  - **Pattern:** `README.md`
  - **Gate:** `grep -qiE 'How the three tools fit|three tools fit' README.md && grep -q 'OpenSpec' README.md && grep -q 'GitNexus' README.md && grep -q 'Graphify' README.md`

- [ ] 2.3 Add kit README pointer to didactic §2.1 / optional add-ons glance (one short note, no duplicate essay)
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -qiE 'narrative|§2\.1|Optional add-ons|without it' sdd-kit/README.md`

## 3. Bootstrap banners and quiet mode

- [ ] 3.1 Implement `--quiet`/`-q` parsing + TTY detection for didactic banners in kit template bootstrap (preserve phase order; keep WARN/ERROR)
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -qE '\-\-quiet|\-q' sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -q 'isatty\|-t 1' sdd-kit/templates/scripts/bootstrap-sdd.sh`

- [ ] 3.2 Add S-layer banners (D3 copy EN + pt-BR via `--chat-lang`/`SDD_CHAT_LANG`) before OpenSpec/GitNexus/Graphify/kit phases
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q 'nobody remembers why\|Sem ela, conversa' sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -q 'reinvents\|reinventa' sdd-kit/templates/scripts/bootstrap-sdd.sh`

- [ ] 3.3 Sync hub `scripts/bootstrap-sdd.sh` to template narrative + quiet behavior (align profile detection with kit warning requirement)
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -qE '\-\-quiet|\-q' scripts/bootstrap-sdd.sh && grep -q 'isatty\|-t 1' scripts/bootstrap-sdd.sh`

- [ ] 3.4 Document `--quiet` in guide §2 and/or `sdd-kit/README.md` for CI/agents
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -q '\-\-quiet' sdd-kit/README.md || grep -q '\-\-quiet' doc/sistema-sdd-pedro.md`

## 4. install.sh optional add-ons teaser

- [ ] 4.1 Append optional add-ons teaser after next-steps in `sdd-kit/install.sh` (pointers only; never call optional installers; honor `CHAT_LANG`)
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -qiE 'Optional add-on|optional add-on' sdd-kit/install.sh && ! grep -E 'install-ui-module\.sh|install-probity-module\.sh' sdd-kit/install.sh | grep -qv '^[[:space:]]*#' ; grep -q '2\.11\|2\.16\|2\.17\|2\.12' sdd-kit/install.sh`

- [ ] 4.2 Ensure dry-run path still prints informational teaser without implying modules were installed
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -n 'DRY_RUN\|dry-run\|Optional\|add-on' sdd-kit/install.sh | head -40; bash sdd-kit/install.sh --help >/dev/null`

## 5. Checksums, validation, and verification

- [ ] 5.1 Regenerate MANIFEST checksums after template bootstrap edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A2 'bootstrap-sdd.sh' sdd-kit/MANIFEST.yaml | grep -q sha256`

- [ ] 5.2 Validate this change strictly with OpenSpec
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate improve-install-narrative --strict`

- [ ] 5.3 Run task-pattern verifier for the change
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`
