## Context

The kit reaches Python 24 times across `sdd-kit/` and `scripts/`. Those call sites are not equivalent, and treating them as one problem produces the wrong fix. They fall into three tiers by consequence:

```
 Tier A — install path            Tier B — upgrade path        Tier C — advisory / verify
 ────────────────────             ─────────────────────        ──────────────────────────
 install.sh:350  MANIFEST parse   upgrade.sh:132  parse        preflight-sdd.sh (x4)
 install.sh:111  language policy  upgrade.sh:261  parse        verify-infra.sh (x3)
                                  sdd-upgrade-diff.sh:29       verify-release-readiness.sh:93
                                                               sdd-session-lib.sh (x4)
                                                               gen-manifest-checksums.sh:45
                                                               install-*-module.sh (x3)
 blocks a first install           blocks an upgrade            degrades a report
```

Only Tier A can stop someone from adopting the system at all. The change prioritises accordingly, but the boundary defects are mechanical and cheap, so Tier B is fixed in the same pass rather than left as a known-broken path.

Five defects were reproduced this session, and they form a chain in which each fix reveals the next:

```
 Windows, python.org Python 3.13 installed
        │
        ▼  D5   name `python3` does not exist → Store alias stub
             preflight FAIL "python3 0.0.0 < minimum 3.10" → bootstrap aborts
        │        loud, but the diagnosis names the wrong problem
        ▼  D2   Python writes \r\n; read -r keeps \r on the last field
             "integrity check failed (expected <X>, got <X>)"
        │        loud, and unreadable — the \r is invisible
        ▼  D3   realpath rejects a missing parent, mkdir -p runs 36 lines later
             abort on .github/workflows/sdd-gates.yml
        │        affects every platform, not just Windows
        ▼  D1   whoever bypasses preflight gets "Done." + exit 0 + zero files
                 silent
```

`bootstrap-sdd.sh` aborts on preflight FAIL (line 110) and `preflight-sdd.sh` exits non-zero when `FAIL_COUNT > 0` (line 470). That machinery is sound and is reused rather than replaced. The gap is narrower than it first appears: `install.sh` invokes preflight only in `--repo` mode, which checks kit presence, writability and a profile hint — nothing about the runtime the script is about to depend on.

Distribution mechanics constrain the shape of any fix. Thirteen scripts exist in both `scripts/` and `sdd-kit/templates/scripts/` under a parity gate, and `MANIFEST.yaml` carries a sha256 per entry across 45 entries. A one-line edit to a template is a three-artifact change: template, live mirror, checksum.

## Goals / Non-Goals

**Goals:**

- A C1 greenfield install completes on native Windows with a python.org Python, with no operator-side shims.
- A C1 greenfield install completes in a repository that has no `.github/`, on every platform.
- The installer refuses to run when it cannot satisfy its runtime, and says which runtime and why, before writing anything.
- No install ever reports success having written nothing.
- CI exercises a greenfield install, so this defect class cannot ship silently again.

**Non-Goals:**

- Removing the Python dependency from the install path. Tracked in issue #364; deliberately excluded so this can ship fast.
- Deciding the long-term native-Windows support stance as a documentation question. Tracked in issue #363. This change corrects the false claim in §1.1; it does not settle the policy.
- Touching Tier C beyond the two boundary sites that corrupt files. Advisory reports that degrade are not blocking anyone.
- Requiring WSL2. Rejected: WSL2 is a Linux kernel in a VM, so requiring it is requiring Linux.

## Decisions

### D1 — Resolve the interpreter by capability, not by name

Probe candidates in order `python3`, `python`, `py -3`, accepting the first whose `sys.version_info` meets the floor. The probe **must** read the version rather than test for existence: `command -v python` succeeds for Python 2, and on Windows it succeeds for the Microsoft Store alias stub, which is not a Python at all. Existence is precisely the evidence that misled the current code.

Measured: with `python3` removed from PATH, the probe resolved `python` 3.13. `py -3 - <<'PY'` accepts a script on stdin with `argv` intact, so the launcher is usable as a drop-in and not merely as a version query.

*Alternative rejected:* asking the operator to create a `python3` shim. That is what a human had to do to get past this, and expecting it of every Windows adopter is the defect, not the remedy.

### D2 — The floor is the kit's own, and it is not Graphify's

No embedded snippet uses syntax above 3.6: no `match`/`case`, no walrus, no PEP 604 unions, no `removeprefix`. Imports are `json, sys, re, os, shutil, uuid, subprocess, datetime, pathlib`. Set the kit's floor at **3.8** — comfortably above what the code needs, comfortably below anything a maintained system ships, and old enough that `sys.stdout.reconfigure` (3.7+) is available if a call site wants it.

Graphify's 3.10 stays where it belongs: a Graphify prerequisite. Guide §2.9.4 already permits deferring GitNexus/Graphify, and an operator who does that must not be blocked by a floor that exists for a component they are not installing.

*Alternative rejected:* keeping a single 3.10 floor for simplicity. It refuses hosts the installer can demonstrably run on, which is the user-visible bug.

### D3 — The runtime check goes into the gate that already exists

`install.sh:222` already calls `preflight-sdd.sh --repo` and already aborts on non-zero. Extend repo mode to verify the interpreter and export the resolved command. One decision point, one FAIL path, one abort message — all specified already in `sdd-install-preflight`.

*Alternative rejected:* a `require_python` helper inlined in each script. Thirteen dual-maintained scripts means thirteen copies to drift. *Also rejected:* a sourced `lib/python.sh`, because `templates/scripts/*` are distributed standalone into consumer repositories and would need fragile relative-path resolution to find it.

### D4 — Newline normalisation differs by site class, deliberately

These two fixes are **not** interchangeable, and using the wrong one silently corrupts data:

| Site class | Fix | Why not the other one |
|---|---|---|
| Feeds a `read` loop with tab-separated metadata | `\| tr -d '\r'` on the feed | Interpreter-agnostic, applied shell-side, and the payload is hashes and paths that can never legitimately contain `\r` |
| Rewrites a file's contents | `open(..., newline='')` on **both** read and write | `tr` would delete carriage returns from file content. A CRLF file would be silently converted |

Reading with `newline=''` matters as much as writing with it. `open(path).read()` in default text mode converts `\r\n` to `\n`, so writing back — even without translation — normalises the whole file. That is exactly D4 observed in the wild: a four-line update to `openspec/infra.md` produced a 153-line diff because the file was rewritten LF-to-CRLF end to end.

*Alternative rejected:* `sys.stdout.reconfigure(newline='\n')` in every emitting block. It works (measured), but it must be remembered at each of the sites and is invisible to a shell-side reviewer. The `tr` filter sits where the corruption enters and is self-documenting at the call site.

### D5 — A zero-length template list is a failure, not a no-op

Process substitution does not propagate its exit status, so `set -euo pipefail` cannot see the failure — this is a documented shell behaviour, not a bug to work around by adding more `set` flags. Count the entries the loop consumed and fail when the count is zero. A MANIFEST that legitimately yields no entries for a profile does not exist and would itself be a defect worth aborting on.

*Alternative rejected:* replacing process substitution with a temporary file so the exit code is visible. It works, but it adds a temp file and cleanup path to the hottest part of install for a check the counter gives directly.

### D6 — `realpath -m` keeps the guard's job

The guard exists to reject destinations that escape the repository root. Measured with `-m`:

```
 ../escape/x.yml     → /tmp/tmp.X/escape/x.yml     BLOCKED
 ../../etc/passwd    → /tmp/etc/passwd             BLOCKED
 ok/file.yml         → /tmp/tmp.X/repo/ok/file.yml ALLOWED
```

`-m` changes only whether a missing component is an error; it does not stop resolving `..`, so the prefix check still catches escapes. The guard keeps its security property and loses only its accidental dependency on directories that the installer is about to create.

*Alternative rejected:* moving `mkdir -p` above the guard. That would create directories before deciding whether the destination is legitimate — using a filesystem write to satisfy a check whose entire purpose is to run before writes.

### D7 — CI installs into an empty repository

Add a greenfield install job to `sdd-gates`: create an empty repo, copy the footprint, run `install.sh`, assert a non-trivial file count and that `.github/workflows/sdd-gates.yml` exists. The last assertion is not incidental — that exact path is what D3 aborts on, and its parent directory is the one a greenfield repo lacks.

The hub cannot substitute for this. Every gate today runs against a repository that already has `.github/workflows/`, which is precisely why a defect fatal to every genuine greenfield install survived undetected.

## Risks / Trade-offs

**A resolved non-`python3` interpreter behaves differently from the one CI exercises** → CI runs Linux where `python3` always wins the cascade, so the `python` and `py -3` rungs stay untested there. Mitigation: the resolution logic is small and version-probed; the greenfield smoke test can force a rung by manipulating PATH if the cost is low.

**`tr -d '\r'` applied to the wrong site class corrupts content** → The distinction in D4 is load-bearing and easy to get wrong under time pressure. Mitigation: the split is normative in the spec, not merely advisory in this document, so a reviewer can check it against a requirement.

**Checksum and parity churn across 13 dual-maintained scripts** → A missed mirror or stale checksum fails `verify-release-readiness.sh` late, after the diff looks finished. Mitigation: regenerate checksums as an explicit task, and treat the readiness gate as the completion criterion rather than a formality.

**Install now aborts where it previously printed `Done`** → Anyone with automation that treats a zero-file install as success will start failing. This is the intended outcome, but it is a behaviour change and belongs in the changelog in plain words, not buried in a bullet.

**Floor divergence between the kit and Graphify invites confusion** → Two numbers where there was one. Mitigation: state both in §1.1 with their reason attached, so the difference reads as deliberate rather than as an inconsistency someone should "fix".

## Migration Plan

No consumer migration is required: a C2 upgrade replaces the affected scripts through the normal `upgrade.sh` flow, and no template that consumers author is touched. Operators who created a local `python3` shim to work around D5 can keep it — the cascade prefers `python3` when it is real, and the shim is real.

Rollback is the ordinary path: these are script fixes, so reverting the commit and cutting a patch restores prior behaviour. That behaviour is "cannot install on Windows", so rollback is only meaningful if a fix proves worse than the defect.

## Open Questions

- Should the greenfield smoke test force the `python`/`py -3` rungs, or is exercising the default rung sufficient for now? Forcing them is more honest and costs a PATH manipulation.
- Does `verify-release-readiness.sh` — itself a Python call site — run early enough in any flow to precede interpreter resolution? Not investigated. If it does, it needs the resolved command too, and the ordering must be explicit.
- Is 3.8 the right floor, or should it track the oldest Python still receiving security support? A fixed number is simpler to reason about; a moving one is more defensible. This change assumes fixed.
