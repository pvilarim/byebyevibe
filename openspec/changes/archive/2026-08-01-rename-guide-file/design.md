# Design — rename-guide-file

## D1. New name and rename mechanics

`doc/byebyevibe-guide.md` — project-named (public name per `2026-07-26-rename-byebyevibe-public-name`), EN, role-descriptive. Rename via `git mv` so blame/history follow the file. The guide's §14 changelog gains a `v1.7.0` entry describing the rename (name-only release; content unchanged).

## D2. Redirect stub (old path)

GitHub does not redirect renamed files, and the old path is cited by every archived change, older PRs, and human bookmarks. Keep `doc/sistema-sdd-pedro.md` as a ≤5-line EN stub:

```markdown
# Moved

This guide is now [`doc/byebyevibe-guide.md`](./byebyevibe-guide.md) (renamed 2026-08, kit v1.7.0).
Archived changes and pre-rename spec requirements cite the old name; both names refer to this same document.
```

The stub is EN-only, so it passes G-PT trivially; it is NOT added to the i18n gate file list (the new path replaces the old one there). Removal of the stub is a future operator decision (candidate: next major kit version).

## D3. The four functional touchpoints (each has a silent or breaking failure mode)

| File | Coupling | If missed |
|------|----------|-----------|
| `scripts/verify-i18n-wave.sh:389` | guide path in the gate's file list | **silent** — guide leaves PT-detection coverage |
| `scripts/sdd-upgrade-diff.sh:14` | grep regex `sistema-sdd-pedro\.md...vX.Y.Z` against `openspec/project.md` | **silent** — `GUIDE_VERSION` empty |
| `scripts/verify-task-patterns.sh:38` | regex special-case `^doc/sistema-sdd-pedro\.md` | future tasks citing the guide fail the pattern gate |
| `scripts/gen-missing-translate-proposes.py` (11 refs) | generates proposals targeting the path | generated proposals reference a stub |

Each has a template mirror in `sdd-kit/templates/scripts/` — hub and template change in the same task (split-brain guard). `sdd-upgrade-diff.sh`'s regex and the `openspec/project.md` line it parses change **together** in one task, and the gate executes the extraction to prove `GUIDE_VERSION` is non-empty.

## D4. Exclusion zones (what stays on the old name, by design)

- `openspec/changes/**` — archives and explore research are immutable history.
- `openspec/specs/**` except the two deltas — 14 spec files cite the guide; most references are historical wave-slice requirements (e.g. `sdd-docs-language` lines 518/532: "lines 133–297 must be English") or pointer text whose intent is unchanged. Mass-editing specs without behavior change is churn and was explicitly declined by the operator.
- `doc/avaliacoes/2026-*` — dated evaluation docs are point-in-time records. (`doc/avaliacoes/README.md`, the live index, IS updated.)

The interpretive bridge for readers of old text is the alias record (D5) plus the ADDED `sdd-docs-language` requirement.

## D5. Alias record

Two one-liners, both greppable:

- `openspec/project.md` (Cross-references): `Guide renamed 2026-08: doc/sistema-sdd-pedro.md → doc/byebyevibe-guide.md (kit v1.7.0); archives/pre-rename specs cite the old name.`
- `AGENTS.md` (near the guide row in the map table): same sentence, compressed.

## D6. Kit release discipline

16 template files change → checksums regenerate via `gen-manifest-checksums.sh`. Per `sdd-kit/README.md:117` and the `sdd-install-kit` version-alignment requirement, a template-visible change is a release: `version`/`guide_version` 1.6.1 → **1.7.0** in MANIFEST, matching guide changelog §14 and `openspec/project.md`/`AGENTS.md` cross-references. Consumer repos converge via `sdd-kit/upgrade.sh` — no bespoke migration.

## D7. Final gate (grep-zero)

```bash
test "$(git grep -l 'sistema-sdd-pedro' -- ':!openspec/changes' ':!openspec/specs' ':!doc/avaliacoes' | grep -v '^doc/sistema-sdd-pedro.md$' | wc -l)" = 0
```

Zero live references outside the exclusion zones except the stub itself. This single check covers both silent failure modes (D3 rows 1–2) and any file missed by the sweep tasks.

## D8. Ordering

1. `git mv` + stub + changelog entry → 2. functional scripts (hub + template mirrors, same task) → 3. config docs + alias → 4. IDE surfaces → 5. remaining docs + kit hub files → 6. remaining templates + checksums + version bump → 7. grep-zero + `sdd-kit/verify.sh` + `openspec validate --strict`. Rationale: the file must exist at the new path before any gate that reads it; checksums regenerate once, after the last template edit.
