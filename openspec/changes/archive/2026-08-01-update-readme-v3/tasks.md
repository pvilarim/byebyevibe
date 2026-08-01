# Tasks — update-readme-v3

## 1. Compare removal (D1)

- [x] 1.1 Remove the `## Compare (summary)` section from `README.md` (heading, stars-disclaimer line, star table); relocate the line "We **compose** OpenSpec; we don't replace it." to the top of "Stack & companions"; keep the evaluation-doc link in the Docs table untouched
  - **Pattern:** `README.md`
  - **Invariants:** `openspec/changes/update-readme-v3/specs/sdd-discovery-positioning/spec.md` (Compare absent, evaluation doc still linked)
  - **Gate:** `! grep -q '## Compare (summary)' README.md && grep -q '2026-07-26-sdd-discovery-positioning.md' README.md && grep -q "compose" README.md`
  - **Forbidden:** deleting or editing `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` or `doc/avaliacoes/README.md`

## 2. Gap-aware content (D2, D3)

- [x] 2.1 Append the sixth **Gap-aware** bullet to "Why install this" in `README.md`, exactly per design D2 (bold lead + offer-only trailing clause)
  - **Pattern:** `README.md` (existing bullet style in "Why install this")
  - **Gate:** `grep -q 'Gap-aware' README.md && grep -qi 'offer-only' README.md`

- [x] 2.2 Insert the D3 paragraph into "Calibrate as you go" (after the metrics paragraph, before the `sdd-metrics.sh` code block), referencing `verify-infra.sh` and the offer-only posture
  - **Pattern:** `README.md` (existing "Calibrate as you go" section)
  - **Invariants:** `openspec/changes/update-readme-v3/specs/sdd-discovery-positioning/spec.md` (offer-only framing, no ML claims)
  - **Gate:** `grep -q 'verify-infra.sh' README.md && ! grep -qiE 'self-learning|machine learning|self-improving' README.md`
  - **Forbidden:** ML/self-learning/auto-adaptation claims anywhere in `README.md`

## 3. Consistency check

- [x] 3.1 Verify the v3 section order end-to-end and run the strict validator
  - **Gate:** `npx -y @fission-ai/openspec@1.3.1 validate --all --strict && ! grep -q '## Compare (summary)' README.md && grep -q 'Gap-aware' README.md && grep -q 'verify-infra.sh' README.md`
