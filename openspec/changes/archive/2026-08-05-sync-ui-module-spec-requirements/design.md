## Context

See proposal.md. This is spec-debt repayment: the implementation exists, the requirements do not. Two facts established by direct inspection rather than assumed:

1. **The behaviours are present.** `sdd-kit/templates/openspec/infra.md:85` and `openspec/infra.md:98` both carry `## UI Development Module`; `doc/byebyevibe-guide.md:608` carries `#### 2.11.1 UI module verification checklist`, referenced from the §2.11 step table at line 596.
2. **No live requirement covers either.** `openspec/specs/sdd-workspace-manifest/spec.md` has 12 requirements, none naming the UI module; its "Manifest sections" list (line 65) omits it. `openspec/specs/sdd-post-install-verification/spec.md` has no requirement mentioning §2.11.1 (`grep -c "2.11.1"` → 0).

## Goals / Non-Goals

**Goals:**
- Make the two shipped behaviours gate-enforceable, so a future refactor that drops them fails `openspec validate`/CI instead of silently regressing.
- Use current wording and current paths, so the result needs no follow-up correction.

**Non-Goals:**
- Reviving PR #17 — see the decision below.
- Touching `sdd-ui-module` (already live and correct on `master`).
- Any template, script, guide, or `MANIFEST.yaml` change — there is nothing to implement, so a kit version bump would signal a payload change that did not happen.

## Decisions

**Decision: MODIFIED for "Manifest sections", ADDED for the §2.11.1 checklist.**
Rationale: `openspec/infra.md`'s required-section list already exists as a single requirement ("Manifest sections"); adding `UI Development Module` to it is an amendment to that list, so `## MODIFIED Requirements` with the full replacement body is the honest delta. The guide checklist has no existing requirement to amend — `sdd-post-install-verification` never mentioned §2.11.1 — so it is `## ADDED Requirements`.
Alternative considered: adding a second standalone requirement ("UI Development Module section in infrastructure manifest", the heading PR #17 used) instead of amending "Manifest sections". Rejected — it would leave two requirements governing the same list, with the canonical list still omitting the section. A reader checking "Manifest sections" would conclude the UI section is optional.

**Decision: close the gap with a new change rather than merging PR #17.**
Rationale: #17's spec text hardcodes `doc/sistema-sdd-pedro.md`, the pre-v1.7.0 guide filename, in 4 places; merging it would reintroduce dead paths that `verify-task-patterns.sh` and the rename convention both reject. Its base is from 2026-06-27, before the rename, the pt-BR→English translation waves, and the v1.8.x releases. Its two requirement headings also differ from the archived deltas' headings (`Infrastructure manifest completeness`, `Post-install verification checklist`), so merging it would create heading drift against the archive record. Writing the requirements fresh costs less than rebasing and correcting a two-month-old branch.

**Decision: state the §2.11.1 reference path as §2.11, not §2.8.**
Rationale: the archived delta claimed §2.11.1 is "referenced from §2.8". Inspection shows §2.8's region reaches the UI module only via the "Optional add-ons at a glance" row pointing at **§2.11**, and §2.11's step 4 then points at §2.11.1 — so §2.8 → §2.11.1 is indirect. Writing "referenced from §2.8" into a requirement would make it false on the day someone greps for it. The requirement therefore mandates the §2.11 reference (directly verifiable) and the extension-not-replacement relationship to §2.8 (the actual normative intent).

## Risks / Trade-offs

- [A stricter requirement could fail an existing consumer repo whose `infra.md` predates the UI module section] → Mitigation: the requirement targets the section list in the manifest template the kit ships, which has carried the section since v1.3.1; consumer repos receive it on their next C1/C2. No profile gate is needed because the section is a `SKIP`-able placeholder on DOCS_SPECS repos without a frontend, exactly as the live `openspec/infra.md` shows.
- [Spec-only change with no tasks touching code could look like a no-op in review] → Mitigation: tasks carry grep gates asserting each mandated behaviour is genuinely present, so the change is self-verifying rather than assertion-only.
