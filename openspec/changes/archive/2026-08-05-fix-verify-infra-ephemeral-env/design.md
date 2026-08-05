## Context

See proposal.md. Facts established by direct inspection during the 2026-08-05 exploration (not assumed):

1. `bootstrap-sdd.sh:244` installs `@fission-ai/openspec` globally, so on a bootstrapped machine `npx openspec` resolves to the PATH binary and works — the committed `✅ 1.3.1` was genuine. The failure surface is exclusively environments that never ran bootstrap.
2. On such machines, bare `npx openspec` resolves through the npm registry to `openspec@0.0.0` (abandoned, no `bin`), and bare `npx gitnexus` prompts to download `gitnexus@1.6.9`. Both are the wrong question: the check wants "is it installed here", which is a PATH lookup.
3. `sdd-gates.yml` lines 72–82 already document the mutation problem ("D4 — report-only") and revert it (`git checkout -- openspec/infra.md`). The design intent — non-operator environments are not authoritative over the manifest — already exists; the script just doesn't implement it.
4. The script is internally inconsistent: Graphify check and the tooling gap-check use `command -v`; only OpenSpec/GitNexus use `npx`.

## Goals / Non-Goals

**Goals:**
- The committed `openspec/infra.md` reflects the operator's canonical workspace; ephemeral environments can report but not overwrite it.
- CLI presence checks answer "installed on this machine" honestly, offline, with no registry side effects.
- Agent apply sessions stop needing manual `git checkout -- openspec/infra.md` before every commit.

**Non-Goals:**
- Making the check pass in environments where the CLIs are genuinely absent (a truthful ❌/absent report is correct there).
- Detecting specific agent platforms (no `$CI`/vendor env-var sniffing — TTY is the general signal).
- Changing what bootstrap installs or how CI orchestrates `verify.sh`.

## Decisions

**Decision: gate manifest writes on interactivity (TTY) or explicit `--write`, and make non-interactive runs advisory (exit 0).**
Rationale: the manifest is committed and shared; a sandbox's local ❌ is not "proof" in the sense of the `sdd-workspace-manifest` "Assume installed until proven otherwise" requirement — it proves absence only for an environment that will be reclaimed within hours. TTY distinguishes the operator at a terminal (authoritative: writes + non-zero exit on failures, unchanged UX) from CI/agents (advisory: report-only, exit 0 — the same posture CI already imposes from the outside via D4 and the restore step). `--write` covers the legitimate non-TTY writer: the operator's own scripted/cron invocation and bootstrap's post-install update.
Alternatives considered:
- *Env-var detection (`$CI`, agent vars)*: enumerates vendors, rots as platforms change; TTY is the mechanism-level signal all of them share.
- *Never exit non-zero anywhere*: loses the operator's local failure signal for no benefit.
- *Keep mutation, rely on CI restore + agent discipline*: the status quo; failed three times in one session and depends on every future agent remembering an undocumented revert.

**Decision: `command -v` for presence; direct binary invocation for detail (version, GitNexus "up-to-date").**
Rationale: `command -v` is the question actually being asked, is offline and instant, and is what the script's other checks already use. Richness is preserved: when present, `openspec --version` reports the real installed version (keeping C2b staleness detection meaningful) and `gitnexus status` keeps the index-freshness signal — invoked directly, not through npx.
Alternative rejected: *pin the scoped package (`npx -y @fission-ai/openspec@1.3.1`)*. With `-y`, npx downloads on demand — the check would pass ✅ wherever npm is reachable, measure "registry availability" instead of "installed", always report the pinned version (blinding C2b), and diverge from what the "Verify with" column tells the user to run. This was the fix first proposed in-session and it is worse than the bug.

**Decision: update the "Verify with" column to direct binary commands.**
Rationale: the column is the user-facing contract of each row; after the check switches to PATH semantics, `npx openspec list` would verify something the check no longer measures. Direct invocation (`openspec list`, `gitnexus status`) matches both the check and the bootstrapped environment.

**Decision: single change, single 1.8.2 release.**
Rationale: all three fixes edit the same script (plus its mirror); splitting would produce two kit releases editing one file in sequence, with the second conflicting with the first — the sliced-work pattern behind the 2026-08-05 duplicate-PR cleanup. Precedent: `clarify-install-scope-ux` shipped bootstrap + preflight + README changes as one release.

## Risks / Trade-offs

- [Operator's non-TTY automation (cron, wrapper script) silently stops updating the manifest] → Mitigation: `--write` flag documented in the script's usage header and in the changelog entry; the report-only notice printed on non-TTY runs names the flag.
- [Exit-0 in report-only mode could mask a real failure in CI] → Accepted: CI already treats `verify.sh` as report-only by design (D4) and independently enforces the blocking gates (`openspec validate`, task patterns, OSV); no signal is lost that CI ever consumed.
- [GitNexus freshness check changes from `npx gitnexus status` to direct `gitnexus status`] → Behaviour identical on bootstrapped machines (same binary); on non-bootstrapped machines the old path downloaded a package to answer a presence question — strictly an improvement.
- [CI restore step becomes redundant] → Kept deliberately (defence in depth, zero cost); removal deferred until 1.8.2 has soaked.
