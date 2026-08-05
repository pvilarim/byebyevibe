## Context

`README.md` already lists the composed stack once at the bottom ("Stack & companions") with only OpenSpec linked, and names it again in the intro paragraph with no links at all. The "Core tools" table (README.md §Core tools) already explains what each project is for — the intro just doesn't point there. This is a docs-only edit confirmed by GitHub search: `GitNexus` → `https://github.com/abhigyanpatwari/GitNexus`, `Graphify` → `https://github.com/Graphify-Labs/graphify` (OpenSpec's existing link, `https://github.com/Fission-AI/OpenSpec`, is unchanged).

## Goals / Non-Goals

**Goals:**
- Every mention of OpenSpec/GitNexus/Graphify in the README is a working GitHub link.
- The intro paragraph gives a one-line pointer into the Core tools table.

**Non-Goals:**
- No change to `sdd-kit/`, install scripts, CI gates, or any spec's normative behavior beyond the link/pointer requirement itself.
- No restructuring of the README's section order (still governed by `sdd-discovery-positioning`'s existing section-order requirement).

## Decisions

- **Link placement**: one new line directly under the intro paragraph (before the "Vibe coding until the first PR" tagline), rather than folding links into the paragraph's prose — keeps the sentence readable and matches the existing "badge line" pattern used elsewhere in READMEs.
- **Anchor target**: link to `#core-tools` (GitHub's auto-generated anchor for the `## Core tools` heading) rather than duplicating the table's content — avoids drift between two copies of the same explanation.
- **Stack & companions**: link GitNexus/Graphify inline in the existing bullet (`- [OpenSpec](...) · [GitNexus](...) · [Graphify](...) · [agents.md](...)`) rather than adding a new list — smallest diff, no new visual structure.

## Risks / Trade-offs

- [Risk] GitHub anchor slugs can change if the heading text changes → Mitigation: anchor matches the current `## Core tools` heading verbatim; if that heading is ever renamed, `sdd-discovery-positioning`'s section-order requirement already forces a review of the README anyway.
- [Risk] Upstream repos could rename/move (e.g. GitNexus/Graphify are fast-moving OSS projects per `doc/byebyevibe-guide.md` §"fast-evolving") → Mitigation: none needed now; broken links are a Type A fix when noticed, not a reason to withhold linking today.
