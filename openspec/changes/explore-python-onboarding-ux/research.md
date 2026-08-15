# Research — Python onboarding UX for non-developer operators

**Date:** 2026-08-07 · **Phase:** explore (no change proposed yet)
**Audience assumption:** initial users have little development experience. Every platform is **Windows or macOS** — no Linux, no WSL assumed.
**Installed base (operator-confirmed):** the original three pre-1.14.0 installs; plus the Windows 1.14.0 incomplete payload in `explore-consumer-install-defects`; plus the macOS Cursor-mediated 1.14.0 bootstrap in §19 (`mvp-viabilidade` — same Mac operator, new repo). All need **repair**, not upgrade. Hub has already tagged **v1.15.0** and **v1.15.1**.
**Trigger:** operator request to make the missing-Python case friendly: warn without blocking, remind at the end, link the official download, and state which version to install.

---

## 1. The requested behaviour is architecturally impossible today

The request is: if Python is missing, warn but let the framework install anyway, then remind at the end.

`sdd-kit/install.sh` uses Python to **read its own file list** — the `MANIFEST.yaml` parse that produces the 45 template entries the installer copies. Without an interpreter the list is empty, so there is nothing to install.

```
   install.sh
       │
       ├── needs Python to read ───▶ MANIFEST.yaml (45 entries)
       │                                    │
       └── copies the files ◀───────────────┘
```

This is not "installs partially". It is "installs zero". Continuing is not a policy choice because there is no installation to continue.

**This exact behaviour was the defect fixed in 1.14.0.** Before that release, a missing interpreter produced a zero-file install that printed `Done. Next steps:` and exited 0 — the operator believed the install had succeeded. The abort is deliberate.

Implementing "warn and continue" on today's architecture would reintroduce that defect with friendlier wording.

### The unblock is issue #364

Issue #364 (reduce the Python dependency in the C1 install path) was filed as hygiene with no urgency. This UX requirement changes its status: **it is the prerequisite.** Only once `install.sh` can read its MANIFEST without Python does the requested model become both possible and correct.

```
   TODAY                              AFTER #364
   ─────                              ──────────
   no Python                          no Python
       │                                  │
       ▼                                  ▼
   install aborts                     install completes (awk reads MANIFEST)
   (correct, but harsh)                   │
                                          ▼
                                      warn: Python needed for X, Y, Z
                                          │
                                          ▼
                                      end-of-install reminder + link + command
```

**Dependency for any proposal built on this research: #364 ships first.**

---

## 2. What actually stops working without Python

Measured call sites per script. This matters because "nothing will work" is false and frightens a beginner; the truth is more reassuring and more actionable.

| Area | Needs Python | Impact for a beginner |
|---|---|---|
| Installing the framework | today **yes** / after #364 **no** | — |
| `/opsx:explore`, `/opsx:propose` | **no** (markdown skills + OpenSpec on Node) | none |
| `/opsx:apply` | **yes**, via `sdd-session-lib.sh` (4 sites) | loses session locking — see §6 |
| `verify-infra.sh` / `verify.sh` | yes (8 sites) | no infrastructure verification |
| Full preflight | yes (26 sites) | no diagnostics |
| Kit upgrade | yes (6 sites) | cannot upgrade |
| Metrics | yes (1 site) | no reports |
| **Graphify** | yes, and **3.10+** | no knowledge graph |

The creative loop — thinking, proposing, specifying — does not need Python. What needs it is the verification, maintenance and knowledge-graph machinery. For a beginner in the first days that is a degradation, not a blockage, and the messaging should say so.

---

## 3. The five states to detect (and why one message cannot cover them)

A single "Python not found" message is wrong in four of these five cases.

| State | Condition | What the operator must do | Notes |
|---|---|---|---|
| **S1** | No interpreter at all | Install Python | The only case the naive message fits |
| **S2** | Present but below 3.8 | Upgrade | Rare on Windows, **common on macOS** (§4) |
| **S3** | A name resolves but is not an interpreter | Install a real Python **and** fix PATH | The most confusing state; both platforms have their own version of it |
| **S4** | 3.8–3.9: kit works, Graphify does not | Optional upgrade, or defer Graphify | **The default state of a stock Mac** |
| **S5** | 3.10+ | Nothing | — |

S3 and S4 are the states that generate support requests, because in both the operator believes Python is installed — and is right. The problem is that the *system* cannot use it.

The resolver shipped in 1.14.0 already distinguishes these correctly (it probes by executing the candidate, not by testing the name). The gap is **messaging**, not detection.

---

## 4. macOS — yes, it changes things, and one finding is a live bug

### 4.1 ~~BUG: the §1.6 recipe does not work on macOS~~ — **RETRACTED, see §17.1**

> **This finding was wrong.** The macOS report (§17) shows `sha256sum` present at `/sbin/sha256sum` on macOS 26.5.1. The claim below assumed historical macOS behaviour and was never verified. It is kept for the record and because the *portability principle* still holds — whether `-c` works there is still open — but the conclusion "the recipe fails on macOS" is retracted.

### 4.1 (original text, retained for the record)

The default acquisition recipe — made the default in v1.13.0 — contains:

```bash
( cd "$TMPDIR" && sha256sum -c byebyevibe-kit.tar.gz.sha256 )   # verify BEFORE extracting
```

**macOS does not ship `sha256sum`.** It ships `shasum` (Perl) and `openssl`. `sha256sum` only exists if the user installed GNU coreutils via Homebrew, which a beginner has not.

The kit's own scripts already handle this correctly — `install.sh` and `gen-manifest-checksums.sh` both detect `sha256sum` and fall back to `shasum -a 256`. **Only the documented recipe hardcodes the GNU name.**

The surrounding prose reinforces the blind spot: it explains the Windows/Git Bash situation in detail and says nothing about macOS, because macOS was assumed Unix-enough to be fine.

Consequence for a Mac beginner following the default path: `sha256sum: command not found`, and the recipe stops at the verification step — before extraction, so nothing is installed and nothing is corrupted. It fails safe, but it fails.

**Severity:** this affects the documented default acquisition path for roughly half the target audience. It is independent of everything else in this research and could be fixed on its own.

**Shape of the fix:** either publish a portable one-liner (`shasum -a 256 -c` when `sha256sum` is absent) or give macOS its own labelled block, the way Windows has one.

### 4.2 `/usr/bin/python3` on macOS is a shim, not an interpreter

macOS ships a `python3` at `/usr/bin/python3` that is a stub for the Xcode Command Line Tools. Behaviour depends on state:

- **CLT not installed:** running it triggers a GUI prompt to install the Command Line Tools. In a script this either hangs waiting for a human or fails oddly.
- **CLT installed:** it becomes a real Python, but the version is tied to the CLT release and **lags** — 3.9.x has been the shipped version across several macOS releases.

This is the direct analogue of the Windows Store alias stub: **a `python3` that exists, is on PATH, and is not usable.** Both platforms have this trap; the details differ, the operator experience is identical.

Two consequences:

1. The 1.14.0 resolver handles it correctly by design (it executes the candidate rather than trusting the name) — but on macOS the *first probe itself* may trigger the CLT GUI prompt. **Not verified on a real Mac. Needs a spike.**
2. A stock Mac with CLT installed lands in **state S4**: kit floor satisfied (3.9 ≥ 3.8), Graphify floor not (3.9 < 3.10). So the *default* macOS experience is "framework works, knowledge graph does not" — and the message must say exactly that instead of implying something is broken.

### 4.3 `realpath -m` does not exist on macOS

BSD `realpath` has no `-m` flag. The traversal guard shipped in 1.14.0 probes for support and falls back to `posixpath.normpath` **via the resolved Python interpreter**.

That fallback is fine today because install already requires Python. **It becomes circular under #364**: a Python-free install path cannot use a Python-based fallback for its path guard. Any #364 proposal must solve the macOS path-normalisation case without an interpreter.

### 4.4 macOS summary

| Item | Windows (Git Bash) | macOS |
|---|---|---|
| `sha256sum` | ships with Git for Windows ✅ | **absent** ❌ (§4.1) |
| `shasum` | present | present ✅ |
| Fake `python3` on PATH | Microsoft Store alias | Xcode CLT shim |
| Default Python version | none installed | 3.9.x via CLT (fails Graphify's 3.10) |
| `realpath -m` | GNU, present ✅ | **absent** ❌ (§4.3) |
| `flock` | **absent** ❌ (§6) | **absent** ❌ (§6) |

Every ❌ in that table affects a documented path. None is theoretical.

---

## 5. Windows — the trap that will catch most beginners

The official python.org Windows installer presents **"Add python.exe to PATH" unchecked by default.**

A beginner downloads Python, clicks *Install Now*, sees "Setup was successful", returns to the terminal, and nothing works. They installed Python. The system still cannot find it.

This is the same class of failure as the Store alias — *Python exists, but not under the name or on the path where it is looked up* — and it is the single highest-frequency failure we can predict for this audience.

**Judgement:** in the end-of-install message, this sentence matters more than the download link. A link the operator follows into the same trap has negative value.

Copy-pasteable alternatives that sidestep the checkbox entirely are worth considering: `winget install Python.Python.3.13` on Windows handles PATH itself; `brew install python` on macOS likewise. See §8.

---

## 6. The session lock — the real question is not "degrade or block"

The original open question was whether the apply lock should block or degrade when Python is unavailable. Reading the implementation changed the question.

`sdd-session-lib.sh` acquires the lock like this:

```bash
( flock -x 200
  while true; do sleep 3600; done
) 200>"$LOCK_FILE" &
echo $! > "$LOCK_HOLDER_PID_FILE"
```

**`flock` is a Linux util-linux tool. It is absent from Git Bash and absent from macOS** — verified absent on the Windows host used for this research; macOS absence is well established but not verified here.

So on 100% of the target platforms, `flock` fails with "command not found". Because it runs inside a backgrounded subshell, that failure is invisible: the subshell proceeds to its `sleep` loop, the PID file is written, and the caller sees a successful lock acquisition. **No file lock is ever held.**

What *does* provide mutual exclusion is the PID-file check immediately above it: if a live process is recorded as holder, acquisition returns 1. That check is pure shell and works everywhere.

### Reframed finding

The lock is **two mechanisms stacked**, and on Windows and macOS only the weaker one runs:

| Mechanism | Works on Win/Mac | Protects against |
|---|---|---|
| PID file + liveness check | ✅ yes | a second apply while the first is running |
| `flock` advisory lock | ❌ no (binary absent) | races the PID check cannot see |

The Python dependency in this file is for reading/writing the session JSON, not for the locking itself.

### Implications

1. **The "degrade or block" question is partly moot** — the `flock` half already degrades silently on every platform we target, and has since it was written. That silent degradation is itself a finding worth fixing independently: a guard that cannot run should say so, not pretend.
2. **For a single operator on a laptop**, the PID-file check is adequate. It protects against the realistic accident (two terminals, same repo) and the scenario it misses (a true race) requires concurrency this audience does not have.
3. **Recommendation for the Python-missing case: degrade, loudly and once.** Print a single line stating that session coordination is unavailable and why, then proceed. Blocking `/opsx:apply` because a concurrency guard for a multi-operator scenario cannot initialise would be disproportionate for a solo beginner — and would contradict the entire premise of this research, which is that a missing optional runtime should not prevent work.
4. **Do not silently no-op.** That is the failure mode of 1.14.0's install bug and of `flock` here. The rule that emerged yesterday applies: *a check that cannot run must say so, never report success.*

---

## 7. Which Python version to recommend

Three risk layers, with very different weights.

### Layer 1 — the kit's own Python code: risk ≈ zero

Imports across all 24 call sites: `json, sys, re, os, shutil, uuid, subprocess, datetime, pathlib`. All stable standard library, no compiled extensions, no third-party packages. Measured syntax ceiling is **3.7** (`subprocess.run(capture_output=, text=)`); the declared floor is **3.8**. None of the modules used appear on any deprecation or removal list. This code runs on any 3.8+ and will keep running for years, including on the newest release.

### Layer 2 — Graphify: the real risk, and it is seasonal

Graphify installs via `uv tool install graphifyy` and pulls dependencies with native compiled components (tree-sitter parsers). Packages of that kind typically take weeks to months after a new Python release to publish prebuilt wheels. An operator installing the newest Python shortly after its release (Python ships every October) may see `uv` attempt to **compile from source**, which requires the build tools that preflight already flags as WARN.

### Layer 3 — removed stdlib modules: not applicable

Python has been removing long-deprecated modules. None of ours is affected.

### Policy comparison

| Policy | For | Against |
|---|---|---|
| **"Install the latest"** | One sentence. Zero ambiguity. The big download button on python.org already is that version | For roughly two months a year, Graphify's install may need to compile |
| "Install one version back" | Avoids the Graphify window | Permanent friction against a seasonal risk; the older-versions page is long and confusing and a beginner will pick wrong |
| Pin an exact version + direct link | No chance of choosing wrong | The link ages; someone must maintain it and nobody will remember |

### Recommendation

**Tell them to install the latest.** The bad case is contained in an **optional, already-deferrable** component: guide §2.9.4 documents deferring Graphify and `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1` exists. The escape hatch is already built and documented. Trading permanent friction for protection against a two-months-in-twelve risk is a poor bargain when the worst case already has a documented exit.

**Do not add an upper bound to preflight.** Maximum-version guards age badly: they produce false alarms every October and require someone to remember to raise them. If Graphify cannot install, let it fail with its own message, which will be more precise than any warning we could write in advance.

**One nuance for macOS:** the stock CLT Python is 3.9.x, which satisfies the kit and fails Graphify. On Mac the recommendation is therefore not "install Python" (they have one) but "install a newer Python **alongside** the system one". Different sentence, same download.

---

## 8. UX design space

```
  A. block with an excellent message      ← where we are (message still terse)
  B. install everything, warn, remind     ← what was requested — requires #364
  C. install Python automatically         ← precedent exists, but...
  D. give the exact platform command      ← near-zero friction, zero intrusion
```

**On option C**, worth knowing: `bootstrap-sdd.sh` **already installs things on the operator's machine** — `openspec` and `gitnexus` via npm, `uv` via `curl | sh`, Graphify via uv. The line "we do not touch the user's machine" was crossed long ago.

But Python differs in kind from those: it is a **system runtime**, not a user-space tool. On Windows it may require administrator rights; on machines with `pyenv` or `conda` it is intrusive and can break existing setups. Installing `uv` under `~/.local` is reversible and invisible; installing Python is neither.

**Preferred combination: B + D.** After #364, install everything, then close with the exact command for the detected platform — copy-paste, not a treasure hunt.

### Message content, drafted for a non-developer

Principles: name the state, say what still works, give one command, name the trap.

- **Never say only "Python not found."** Say what the operator can and cannot do without it (§2 table).
- **One command, already correct for their platform**, rather than a link to a page with choices.
- **Windows:** if directing to the python.org installer, the PATH checkbox sentence is mandatory. Preferring `winget` avoids the trap entirely.
- **macOS:** distinguish "you have no usable Python" from "you have 3.9, which runs the framework but not the knowledge graph" — those are different sentences with different urgency.
- **End-of-install reminder** is the one that stays on screen. It should repeat the command, not just the diagnosis.

---

## 9. Findings that stand alone (fixable without #364)

Ordered by how soon they hurt someone:

1. **§4.1 — the §1.6 recipe fails on macOS** (`sha256sum` absent). Affects the documented default acquisition path for half the audience, today. Independent of everything else here.
2. **§6 — `flock` is absent on both target platforms**, and its absence is silent. The concurrency guard is weaker than it appears, on every machine we target.
3. **§4.3 — the `realpath -m` fallback depends on Python**, which becomes circular under #364. A constraint on that proposal, not a bug today.

---

## 10. Alert ordering during install

The principle: **warn before work that could be wasted, remind after because that is what stays on screen.** Silence in between — repetition trains operators to skip.

```
┌─ PHASE 0 — preflight, before touching any file ────────────────┐
│  Detected system: macOS 14 (Apple Silicon)                     │
│  Python: 3.9.6 at /usr/bin/python3                             │
│                                                                 │
│  ✓ Enough to install the framework (minimum 3.8)                │
│  ⚠ Not enough for Graphify (needs 3.10)                         │
│                                                                 │
│  For the knowledge graph:  brew install python                  │
│  You can continue now and install it later.                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                    ── install runs, silently ──
                              │
┌─ END — the last thing on screen ───────────────────────────────┐
│  Installed ✓                                                    │
│                                                                 │
│  ⚠ Missing: Python 3.10+ for Graphify                           │
│    Works now:      /opsx:explore, /opsx:propose, /opsx:apply    │
│    Does not work:  knowledge graph, infra verification          │
│    To fix:         brew install python                          │
└─────────────────────────────────────────────────────────────────┘
```

Three reasons for this shape: at the start the operator can still abort and fix first; at the end it survives a full terminal scroll; and the closing block states **what works**, not only what is missing — a beginner who reads "Python missing" assumes nothing is usable.

OS detection already exists at `scripts/preflight-sdd.sh:237` (`uname -s`, with a `Darwin)` branch) but is scoped narrowly to build-tools advice. Extending it to drive operator messaging is a `case` statement, not new infrastructure.

| Platform | `uname -s` returns |
|---|---|
| Windows (Git Bash) | `MINGW64_NT-10.0-26200` |
| macOS | `Darwin` |

---

## 11. Upgrading the existing installations — the tool that upgrades is itself broken

All three known installations predate 1.14.0. The documented upgrade path (§2.9) routes through `scripts/sdd-upgrade-diff.sh` — **the operator's own installed copy**, which carries the very defects being fixed.

```
   Consumer on ≤1.13.0 wants to upgrade
                │
                ▼
   runs  scripts/sdd-upgrade-diff.sh      ← their copy, with the bug
                │
        ┌───────┴───────┐
        ▼               ▼
      macOS          Windows
   python3 = CLT    python3 = Store stub
   real (3.9)              │
        │                  ▼
        ▼          empty list → "nothing to upgrade"
    works ✓        (the same silent no-op 1.14.0 removed)
```

| Consumer | Result of attempting the documented upgrade |
|---|---|
| **macOS**, CLT Python 3.9 | Works. The CRLF defect is Windows-only |
| **Windows**, Store stub only | Empty list → reports nothing to do → silent no-op |
| **Windows**, real `python3` | CRLF corrupts the parsed fields → wrong diff |

A second layer compounds it: `scripts/sdd-upgrade-diff.sh` is classified **`merge: MERGE`** in the MANIFEST, and `upgrade.sh --apply` only applies `COPY` entries (`sdd-kit/upgrade.sh:295`). That is deliberate — a spec requirement preserves local customisation of that script. But here the design fights the bugfix: **a broken copy would be preserved by a successful upgrade.**

### The repair is simpler than the upgrade ceremony

What changed in 1.14.0 is a small, enumerable set, none of it operator-curated content:

- `sdd-kit/` (whole directory — kit-owned, no local customisation expected)
- `scripts/*.sh`
- `.github/workflows/sdd-gates.yml`

So the repair is **re-acquiring the footprint and overwriting**, exactly as a fresh install does, with no `upgrade.sh` involved. That sidesteps both the circularity and the `MERGE` preservation problem in one move.

With three known installations, this can be a direct message to three people rather than a documented migration procedure. It should still be written down somewhere, because "how do I get from an old version to 1.14.0" will be asked again by whoever finds the repo later.

**Note for a future proposal:** the `MERGE` classification of `sdd-upgrade-diff.sh` remains a hazard for *future* upgrades that fix bugs in that file. Preserving local customisation and delivering a security/correctness fix are in tension; the current MANIFEST vocabulary has no way to say "preserve local edits, but this version is mandatory".

---

## 12. Hypothesis: pre-1.14.0 could not install on macOS at all

Before 1.14.0, `sdd-kit/install.sh:234` read:

```bash
dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
```

`--no-symlinks` is a **GNU long option**. macOS ships the BSD `realpath`, which does not accept it. Under `set -euo pipefail`, a failing command substitution inside an assignment aborts the script — and this line runs inside `apply_file`, so it would fire on the **first template**, before anything is written.

If that reading is correct, then:

- No pre-1.14.0 installation on macOS ever completed. It would fail loudly and immediately, not silently.
- **1.14.0 is the first version capable of installing on macOS**, because it probes `-m` support and falls back to `posixpath.normpath` (`install.sh:384`, `:266-269`).
- The question "how do we repair already-installed Mac systems" may have no subject — there may be none.

**Confidence: high on the GNU-vs-BSD option, unverified on the outcome.** Three ways this could be wrong: the operator installed GNU coreutils via Homebrew and exposed it as plain `realpath`; a recent macOS shipped a GNU-compatible `realpath`; or the install was done through a path that bypasses `apply_file`.

**This is the single highest-value question to resolve**, because it determines whether §11's repair procedure needs a macOS branch at all.

---

## 13. Solution inventory — is every problem covered?

| # | Problem | Solution | Status |
|---|---|---|---|
| 1 | §1.6 recipe fails on macOS (`sha256sum` absent) | Portable check: `sha256sum` or `shasum -a 256` | ✅ trivial, no dependency |
| 2 | Windows PATH checkbox trap | Explicit sentence + prefer `winget` | ✅ messaging only |
| 3 | macOS CLT `python3` shim | Resolver already executes the candidate rather than trusting the name | ✅ shipped in 1.14.0 |
| 4 | macOS stock Python 3.9 < Graphify 3.10 | Attributed WARN naming Graphify | ✅ shipped in 1.14.0 |
| 5 | Install blocks when Python is missing | Make install Python-free | ⏳ requires #364 |
| 6 | `flock` absent and silent on both platforms | Detect and state best-effort; PID check already works | ✅ easy, decision needed |
| 7 | `realpath -m` absent on macOS | Probe + `posixpath.normpath` fallback | ⚠️ works today; **circular under #364** |
| 8 | Windows consumers cannot self-upgrade | Re-acquire footprint, skip `upgrade.sh` | ✅ §11 |
| 9 | `merge: MERGE` preserves a broken `sdd-upgrade-diff.sh` | Moot for this repair (bypassed); unresolved for future bugfix upgrades | ⚠️ partial |
| 10 | Alert ordering / beginner-readable messaging | §10 | ✅ design agreed, not built |
| 11 | **macOS has never been executed, ever** | — | ❌ **no solution without a Mac** |

Eight are solved or trivially solvable. Two are partial and both point at the same place: **#7 and #9 are constraints on future work, not open wounds today.**

Item 11 is the honest gap. Everything in this document about macOS is inference from documented tool behaviour, not observation. Yesterday's session produced two independent demonstrations of what happens when a path is documented but never walked — the `-f` class of bug in the acquisition recipe, and the `realpath` defect that survived because CI always ran where `.github/` already existed. **§4.1 and §12 were both found by reading, and both would have been found instantly by running.**

---

## 14. macOS diagnostic — sent 2026-08-07, awaiting reply

One of the three known installations is on macOS. A read-only diagnostic was sent to that operator to run in Cursor. It is recorded verbatim below because the answers only mean something alongside the questions. It was written in Portuguese — the recipient's language — deliberately: a prompt that executes commands on someone's machine should be readable by the person deciding whether to run it.

**Guarantee given:** strictly read-only. Nothing installs, modifies or deletes. Failures are to be recorded and stepped over, since a failure is the evidence being sought.

```bash
echo "===== 1. SISTEMA ====="
sw_vers; uname -m; echo "shell: $SHELL"; echo "bash: $(bash --version 2>/dev/null | head -1)"

echo; echo "===== 2. VERSÃO DO KIT INSTALADO ====="
grep -E '^version:|^guide_version:' sdd-kit/MANIFEST.yaml 2>&1 || echo "sdd-kit/MANIFEST.yaml AUSENTE"
grep -iE 'byebyevibe-guide|guia de instalação' openspec/project.md 2>/dev/null | head -2 || echo "sem referência em project.md"

echo; echo "===== 3. REALPATH (a pergunta mais importante) ====="
command -v realpath || echo "realpath AUSENTE"
realpath --version 2>&1 | head -1
echo "--- teste A: --no-symlinks (o que a versão antiga usava) ---"
realpath --no-symlinks /tmp 2>&1; echo "exit=$?"
echo "--- teste B: -m com pai inexistente (o que a versão nova usa) ---"
realpath -m --no-symlinks /tmp/nao-existe-xyz/ficheiro.txt 2>&1; echo "exit=$?"
echo "--- coreutils do Homebrew instalado? ---"
command -v grealpath || echo "grealpath ausente"
brew list coreutils >/dev/null 2>&1 && echo "coreutils via brew: SIM" || echo "coreutils via brew: nao"

echo; echo "===== 4. PYTHON ====="
for c in python3 python; do
  echo "--- $c ---"
  command -v $c || echo "  ausente"
  $c --version 2>&1
  $c -c 'import sys; print("  executavel:", sys.executable)' 2>&1
done
echo "--- /usr/bin/python3 e Xcode ---"
ls -l /usr/bin/python3 2>&1
xcode-select -p 2>&1

echo; echo "===== 5. FERRAMENTAS QUE O SISTEMA ASSUME ====="
for t in sha256sum shasum flock curl tar git awk; do
  printf "%-12s " "$t"; command -v $t || echo "AUSENTE"
done

echo; echo "===== 6. A INSTALACAO FICOU COMPLETA? ====="
for f in AGENTS.md CLAUDE.md openspec/project.md openspec/infra.md \
         .github/workflows/sdd-gates.yml .cursor/rules/000-base.mdc \
         scripts/preflight-sdd.sh scripts/verify-infra.sh; do
  [ -e "$f" ] && echo "OK      $f" || echo "FALTA   $f"
done
echo "ficheiros em scripts/: $(ls scripts/*.sh 2>/dev/null | wc -l)"
echo "regras em .cursor/rules/: $(ls .cursor/rules/*.mdc 2>/dev/null | wc -l)"

echo; echo "===== 7. FERRAMENTAS SDD ====="
openspec --version 2>&1 | head -1
npx gitnexus status 2>&1 | head -3
graphify --version 2>&1 | head -1
ls graphify-out/GRAPH_REPORT.md 2>&1
```

Three narrative questions were asked alongside, and they carry as much weight as the command output:

1. Did the install **finish successfully**, or fail partway? If it failed, what did the error say?
2. Did you have to do anything **outside what the guide instructed** — install Python, install Homebrew, run an extra command, work around a problem?
3. Since installing, has anything **never worked**, or failed every time you tried it?

### What each block decides

| Block | Resolves |
|---|---|
| 3 | The §12 hypothesis. If `realpath --no-symlinks /tmp` errors, the pre-1.14.0 install could not have completed — and question 1 says whether it in fact did not |
| 3 (brew) | The alternative explanation: Homebrew coreutils exposing a GNU `realpath` |
| 4 | Whether their `python3` is the Xcode shim or a real interpreter, and its version (3.9 fails Graphify, 3.10+ does not) |
| 5 | Confirms §4.1 (`sha256sum` absent) and §6 (`flock` absent) on a real Mac |
| 6 | Whether the install completed, and **where** it stopped — direct evidence for §12 |

**Question 2 is the most valuable of the three.** Any workaround the operator had to invent is precisely the friction this work exists to remove — and if one person invented it silently, others are hitting the same wall without reporting it.

---

## 15. Sequencing decision — why this research does not yet become a proposal

The findings split cleanly by whether the macOS report changes them:

| Independent of the report | Changed by the report |
|---|---|
| §4.1 portable checksum (the absence of `sha256sum` on macOS is not in doubt, and the fallback is correct regardless) | §11 repair procedure — needs a macOS branch **only if** a macOS install ever completed |
| §5 Windows PATH messaging | §3/§10 messaging — which states actually occur in the wild |
| §6 `flock` best-effort statement | §12 — confirmed or refuted outright |
| #364 as a separate track | Whether the Xcode prompt fires during detection |

Writing the proposal now means drafting a repair section that the report may delete entirely, and messaging for states that may not occur. Yesterday produced two independent demonstrations of the cost of documenting an unwalked path; waiting one day for observation is cheap by comparison.

**Decision: hold the proposal until the macOS report arrives.** The exception is §4.1 — if a new macOS operator is expected to install before then, that fix should not wait behind a diagnostic, because it breaks the documented default path today.

---

## 17. macOS report received — 2026-08-07

Machine: macOS **26.5.1** (arm64), zsh, **bash 3.2.57**. Kit reported as 1.14.0 but in a mixed state (see §17.6). One of the three known installations.

### 17.1 What I got wrong

**`sha256sum` exists on macOS 26** at `/sbin/sha256sum`. §4.1 is retracted. The claim rested on historical macOS behaviour and was never verified — the exact failure mode this document warns about twice. Open: whether that binary supports `-c`, and whether older macOS versions ship it at all.

### 17.2 What was confirmed

```
realpath --no-symlinks /tmp  →  illegal option -- -   exit=1
realpath -m …                →  illegal option -- m   exit=1
grealpath: absent · coreutils via brew: no
flock: ABSENT
python (no 3): ABSENT
```

The §12 hypothesis holds: **no pre-1.14.0 install could have completed on macOS.** BSD `realpath` rejects both GNU flags and there is no GNU fallback on the machine. §6 (`flock` absent) also confirmed on a real Mac.

### 17.3 The installation is not functional

It "completed" only after local patches, and the current state has concrete gaps:

| Symptom | Consequence |
|---|---|
| `openspec/project.md` **never created** | No project constitution; language policy never written |
| `AGENTS.md` contains only the GitNexus block | The core governance file was never installed |
| `gitnexus status` → `fatal: ambiguous argument 'HEAD'` | Repo has no initial commit; code graph never indexed |
| Kit 1.13.0 tarball + 1.14.0 scripts + local patches | Mixed state; checksums diverged |

And `sdd-kit/verify.sh` **passed** on that state. See §17.5 (N5).

### 17.4 New defects — macOS portability was never real

**N1 — macOS ships bash 3.2.57 (2007).** Apple does not ship bash 4+ for GPLv3 reasons. **No script in the kit checks the bash version.** The operator reported failure at `heredoc inside process substitution`, a pattern present at five sites (`install.sh:400`, `upgrade.sh:141`, `upgrade.sh:270`, `sdd-upgrade-diff.sh:38` and its mirror). No bash-4-only constructs (`declare -A`, `mapfile`, `${var,,}`) exist — so the version dependency is this one pattern, not the whole codebase.

**Uncomfortable possibility:** the pattern predates 1.14.0, but 1.14.0 made it more complex by adding `| tr -d '\r'` inside the process substitution to fix Windows CRLF. Whether the pipe is the bash 3.2 trigger, or the construct already failed, is **untested** — §18 test A resolves it. If the pipe is the trigger, the Windows fix caused a macOS regression.

**N2 — `sed -i` is mutually incompatible between BSD and GNU.** BSD requires `sed -i ''`; GNU rejects `-i ''`. Six call sites: `preflight-sdd.sh:385`, `verify-infra.sh:55`, `verify-infra.sh:240`, `install-ui-module.sh:139`, plus template mirrors. **There is no portable one-liner** — this needs a probe or a temp-file-plus-`mv` rewrite.

**N3 — `AGENTS.md` is destroyed by execution order.** `bootstrap-sdd.sh:3` declares `# C1 order: OpenSpec → GitNexus → Graphify → sdd-kit/install.sh (MUST NOT change)`. `gitnexus analyze` (line 259) injects its block into `AGENTS.md` **before** `install.sh` (line 291) runs. `merge_agents_profile` then finds the file present and emits `KEEP AGENTS.md (exists — merge manually or delete for fresh install)` — so the kit's `AGENTS.md` is never written. The order is marked MUST NOT change, so the remedy is not reordering.

Independently observed: the same injection happened on the Windows host on 2026-08-06 during `npx gitnexus analyze --force`, and was reverted manually. On a fresh install it guts the file instead.

**N4 — `openspec init` failure is silenced.** `bootstrap-sdd.sh:246`:

```bash
openspec init --tools "cursor,claude" "$REPO" 2>/dev/null || openspec init --tools "cursor,claude"
```

`2>/dev/null` hides the reason. If it fails, `project.md` is absent and nobody learns why. Same family as the 1.14.0 install defect: a step that fails in silence.

**N5 — `verify.sh` passes when `project.md` is absent.** `sdd-kit/verify.sh:124` is `if [[ -f project.md ]]; then …` — when the file does not exist, the entire check is skipped rather than failed. A repository with no constitution passes verification. Third instance of the vacuous-pass pattern in two days.

**N6 — GitNexus fails in a repository with no initial commit.** `fatal: ambiguous argument 'HEAD'`. The kit's own CI greenfield smoke test does `git init` with no commit, but never invokes GitNexus, so this was invisible.

**N7 — the interpreter cascade is effectively single-rung on macOS.** `python` (unsuffixed) is absent and there is no `py` launcher. If `python3` is broken, `python3` → `python` → `py -3` has nothing left. Version-suffixed candidates (`python3.14`, `python3.13`) would add real rungs on macOS.

**N8 — OpenSpec version drift.** The operator has **1.8.0**; the kit declares `min_openspec: 1.3.1` and CI pins 1.3.1. Five minor versions of upstream drift against which nothing has been tested — a strong candidate cause for N4.

### 17.5 The pattern that keeps recurring

N4 and N5 are the same failure as the 1.14.0 install bug, the release-readiness gate, and `flock`: **a step that does not run reports success.** Five instances in two days, in five different files. This has stopped being coincidence and deserves a cross-cutting rule rather than five point fixes.

### 17.6 What the operator had to invent (question 2 — the most valuable answer)

- Install Node.js 20 via Homebrew (absent from PATH — preflight correctly FAILed, so this one worked as designed)
- Download the v1.13.0 release, then overlay scripts from master/PR #367 because 1.14.0 had no release yet
- Local patches to `install.sh` and `preflight-sdd.sh`
- Attempt to install bash 5 via brew (outcome unclear)
- Adjust the `sdd-gates.yml` template and regenerate checksums

Every item is friction this work exists to remove. The bash 5 attempt is the most telling: the operator independently diagnosed N1 and tried to work around it.

### 17.7 Scope consequence

This is no longer "Python onboarding UX". macOS support was never real, and it is five independent layers: `realpath`, `sed`, `bash`, `AGENTS.md` ordering, and the single-rung cascade. 1.14.0 fixed the first by accident. **Two separate changes are indicated:**

1. **`fix-macos-portability`** — N1, N2, N3, N6, N7 (+ N4/N5 as the vacuous-pass rule). This is what stops macOS from working. One of three known operators is affected today.
2. **`add-python-onboarding-ux`** — §3, §10 messaging and the non-blocking model. Depends on #364 and is now clearly the lower priority.

---

## 18. Open questions

Status after the second Mac dump (§19). **No further probe will be sent** — two diagnostics is the cap.

- **Is §12 correct — did any macOS install ever complete before 1.14.0?** **Closed enough for release.** §17 confirmed BSD `realpath` rejects both GNU flags with no Homebrew coreutils on that machine. The second dump is a 1.14.0 Cursor-mediated bootstrap and cannot speak to pre-1.14.0 history. Repair procedure: treat Mac the same as Windows — re-acquire the latest footprint and overwrite; no Mac-specific upgrade branch.
- **Does the resolver's first probe trigger the Xcode CLT GUI prompt on a Mac without CLT installed?** **Won't test.** This operator has CLT (`/usr/bin/python3` = 3.9.6) and a python.org 3.14 in front. The 1.15.0 cascade already places `/usr/bin/python3` last. Leave the residual risk recorded; do not block a release on it.
- **Should session coordination degrade or be stated as best-effort?** **Closed in 1.15.0** (`fix-consumer-install` D11 9e). `flock` was confirmed absent in §17; the second dump did not retest it. Shipped: one INFO line, PID-file is the active guard.
- **Can an `awk` MANIFEST parser (#364) be trusted to gate the install?** **Unchanged — #364 / 1.16.0.** Second dump shows stock Mac `awk`, `paste -sd`, `find -not` work. Not a 1.15.x release item.
- **How should the MANIFEST express "preserve local edits, but this version is mandatory"?** **Unchanged — not Mac.** `explore-agent-mediated-install` D7 already answered the comparison UX; vocabulary gap remains for a later change.

---

## 19. Second Mac dump — 2026-08-14 — session closed

**No third probe.** Two diagnostics is the cap. This section is the evidence record for a release decision.

**Operator statement (2026-08-15):** she installed **directly from a Cursor prompt**, not from guide §1.6 / `bootstrap-sdd.sh`. That is the install vector. The dump is a second targeted probe (blocks A–J) sent after §17; the probe script itself was never committed.

**Machine / repo (from the dump, not from a new question):**

| Fact | Value |
|---|---|
| bash | 3.2.57(1)-release `arm64-apple-darwin25` (macOS 26 family). Homebrew bash **not** installed |
| Kit in the repo | **1.14.0**, checksums OK (45/45) |
| Branch | `cursor/initial-sdd-bootstrap` — **no commits** |
| OpenSpec | **1.8.0**; `init` exit 0; created `openspec/{changes,config.yaml,specs}`; **no `project.md`** |
| GitNexus slug in `AGENTS.md` | `mvp-viabilidade` (55 symbols claimed; `gitnexus status` still says not indexed) |
| `AGENTS.md` | 42 lines; GitNexus block present; **kit content absent** |
| Staged files | only `.claude/commands/opsx/*` and `.claude/skills/*` from `openspec init` |
| Local patches section | empty |
| Python now | `python3` / `python3.14` = python.org Framework **3.14**; `python3.12` present; brew `python3.11`; `/usr/bin/python3` = CLT **3.9.6**; unsuffixed `python` and `py` absent |

This is **not** the mixed 1.13-tarball + 1.14-scripts + local-patches state of §17.6. It is a later Cursor-mediated bootstrap that stopped after `openspec init` + a GitNexus injection. `install.sh` did not apply the kit payload (or left no trace of having done so).

Hub context at the time of this record: `fix-consumer-install` is applied (29/29) and **v1.15.0 / v1.15.1 are already tagged**. The operator's repo is still on 1.14.0.

### 19.1 What each block decided

| Block | Finding | Release consequence |
|---|---|---|
| **A** bash 3.2 | A1 (no pipe) and A2 (with pipe) both `linhas=2 exit=0` | The "pipe is the 3.2 trigger" hypothesis is **false** on this host. N1 as originally reported (heredoc-inside-process-substitution failure) is **not reproduced** by this test. The 1.15.0 temp-file rewrite stays: process substitution still swallows the generator's exit code (`sdd-fail-loud`). Do **not** add a bash-version gate. Do **not** require Homebrew bash. |
| **B** `sha256sum -c` | `/sbin/sha256sum -c` exit 0; `shasum -c` exit 0 | design.md Q1 **closed**. Portable digest compare in 1.15.0 remains correct (does not depend on `-c`). |
| **C** `sed -i` | GNU form exit 1; BSD form exit 0; no leftover files | N2 **confirmed**. 1.15.0 temp+`mv` is the right fix. |
| **D** path without Python | existing `/tmp` → `/private/tmp` exit 0; missing path exit 1; `realpath -q` and `readlink -f` exit 1 | §4.3 / #364 **confirmed**: no `-m`, no GNU `readlink -f`. Darwin `/tmp` → `/private/tmp` means any traversal guard must normalise both sides. 1.15.0 already falls back to `posixpath.normpath` when `-m` is absent. Not a new 1.15.x patch. |
| **E** interpreter cascade | version-suffixed rungs exist; `python` / `py` do not | N7 **confirmed structurally**. This machine is no longer S4 — resolver 1.15.0 would pick `python3` → **3.14** (S5). Messaging that says "Mac stock = 3.9, Graphify will not run" would be **wrong for this operator today**. |
| **F** gate tools | `paste -sd`, `od`, `cmp`, `grep -qF`, `find -not`, `mktemp -d`, `date -u` ok; brew present | Common gates are fine on this Mac. `awk BINMODE: 1` is ambiguous without the probe script — do not introduce gawk-only `BINMODE` (already a 1.15.0 design constraint). `flock` was not retested; §17 stands. |
| **G** `openspec init` | exit 0, no `project.md` | N4 **reframed**. Init did not fail — it succeeded without a constitution. Silencing stderr was the wrong bug. The 1.15.0 `project.md` MERGE template (D4) is the fix. OpenSpec 1.8.0 vs pin 1.3.1: init itself works; do not block 1.15.x on N8. |
| **H** GitNexus | "Repository not indexed" with and without a commit | N6 **out of scope** (already a 1.15.0 non-goal). Softer wording than §17's `fatal: HEAD` — do not chase. |
| **I** `AGENTS.md` | kit content = 0; GitNexus block = 1 | N3 **reconfirmed** on a second repo. 1.15.0 `SDD_AGENTS_PREEXISTED` is the fix — and it only runs if **bootstrap** runs. A Cursor prompt that only calls `openspec init` never hits it. |
| **J** repo | no commits; only init-generated `.claude/` staged; kit 1.14.0 | Confirms the vector: **agent stopped at OpenSpec init**. Payload install did not complete. |

### 19.2 What this does *not* justify

- A 1.15.2 (or 1.16.0) whose only Mac story is "more bash/sed/realpath patches". Those shipped in **1.15.0** (portability by construction) and **1.15.1** (`upgrade.sh` BSD `realpath`).
- Another diagnostic prompt to this operator.
- A bash 5 / Homebrew bash prerequisite.
- Gating install on OpenSpec 1.8.0 compatibility beyond what 1.15.0 already does (loud init + shipped `project.md`).

### 19.3 What a *new* release must actually fix

The operator's install vector is the one `explore-agent-mediated-install` already named: paste the hub URL into Cursor and ask the agent to install.

```
  o que ela fez                         o que 1.15.0 conserta
  ─────────────                         ─────────────────────
  prompt Cursor no repo                 scripts portáteis (sed, MANIFEST
       │                                via ficheiro, cascade, flock,
       ▼                                project.md template, AGENTS snapshot)
  agente encontra o hub
  README / AGENTS.md do hub
       │
       ▼
  openspec init  ──▶  .claude/ + openspec/ sem project.md
  gitnexus analyze ──▶ AGENTS.md = bloco GitNexus
  install.sh        ──▶ NÃO CORREU
```

1.15.0/1.15.1 already make `install.sh` / `bootstrap-sdd.sh` safe on this Mac **if they run**. They did not run.

The next release that changes *her* outcome is therefore **not more portability**. It is the agent-mediated path (already scoped as 1.16.0 in `fix-consumer-install` non-goals and decided in `explore-agent-mediated-install` D1–D6):

1. **Single acquisition:** latest release tarball, not "clone the hub and improvise".
2. **Agent instructions the agent will actually see first** (`README.md` + tarball `INSTALL.md`): download tarball → verify digest → `install.sh` (or `bootstrap-sdd.sh`). **Stopping after `openspec init` is a failed install.**
3. **Hub `AGENTS.md` must not hijack** an agent that opened the repo to install a consumer (D6).
4. **Confirmation block** the human sees (profile + languages + kit version) before writes (D3/D4).

### 19.4 Repair of *this* operator — no probe, no `upgrade.sh`

Same rule as §11 / 1.15.0 changelog: existing installs need **repair**, not upgrade. For `mvp-viabilidade`:

- Re-acquire **v1.15.1** (`byebyevibe-kit.tar.gz` from `releases/latest`).
- Run `sdd-kit/install.sh` in that repo (payload + `project.md` template + language block + kit `AGENTS.md`).
- Do **not** send another diagnostic. A single repair prompt to her Cursor session is enough — that is an install instruction, not a third probe.

### 19.5 Closed vs left for 1.16.0

| Item | Status |
|---|---|
| sha256sum `-c` on macOS 26 | Closed — works; portable compare still required |
| N1 pipe-as-3.2-trigger | Closed — false on this host |
| N2 `sed -i` | Closed — confirmed; shipped 1.15.0 |
| N3 `AGENTS.md` | Closed as a script defect (1.15.0); **reopened as an agent-path defect** (init-only) |
| N4 `openspec init` | Closed as silence; reframed as "succeeds without `project.md`" — shipped template 1.15.0 |
| N6 GitNexus / no commit | Recorded, out of scope |
| N7 cascade | Closed — 1.15.0 rungs match this machine |
| N8 OpenSpec 1.8.0 | Init works; no 1.15.x gate |
| CLT GUI prompt | Won't test — do not block release |
| §12 pre-1.14.0 history | Closed enough — one repair procedure for all platforms |
| Agent stops at `openspec init` | **The remaining Mac-install bug. 1.16.0.** |
