# Product validation portfolio case

This note records a source-backed local case that motivated the generic product-validation protocol. It is not portable consumer evidence, not a benchmark guarantee and not an Astra trial.

## Source identity

The approved portfolio prototype remains in `C:/apps/pedrocode.art`. Its local report is `doc/experiments/cube-scene-local.md`, dated 2026-09-06. The report states that Pedro accepted the visual result on 2026-09-06 and requested retaining the version in the original repository for continued development.

Reported source identifiers:

| Item | Identifier |
|---|---|
| Baseline commit | `ec0f201501fee07341e3d85e2020d5427b717e48` |
| Candidate `js/portfolio.js` SHA-256 | `c6cf907722eb1713c485f609e09f4833c5e0409feb51faad53e674be97ec5155` |
| Helper `js/scene-quality.js` SHA-256 | `43f1428e7843b22b5d178951e8742763cc1127114b1680142d788962cefb9b05` |

These are local source locators. The raw screenshots and JSON were recorded as ignored local artifacts under `.cache/cube-preview/` in the portfolio repository. The measurement harness overwrites the latest result for each variant, so previous attempts are not append-only.

## Observed result

The local report records final short desktop observations of about 204 versus 22 GL draw calls per rendered frame and 3.569 versus 0.523 ms mean synchronous RAF CPU time. It also records two candidate desktop frames over 50 ms. Candidate mobile was emulated, not measured on a physical device.

The result supports a process lesson: structural checks and a green run can miss product defects, and performance claims need declared boundaries. It does not establish a universal FPS improvement, GPU-time improvement, stutter-free behavior, real-device result or statistically controlled benchmark.

## Limitations

- Initial preview runs had image-loading defects that were corrected before the final recorded runs.
- Random initialization, cache/order effects and long-duration behavior were not controlled.
- Raw early failed attempts were not retained in an append-only evidence directory.
- Mobile evidence came from emulation.
- The case was not registered prospectively under this product-validation protocol.
- No Astra admission, budget, model configuration, comparative workflow or H1-H7 evaluation existed for this work.

## Separated outcomes

| Outcome type | Case status |
|---|---|
| Product behavior | Candidate locally implemented and checked for the listed scope in the portfolio report. |
| Human visual acceptance | Accepted by Pedro for the recorded revision on 2026-09-06. |
| Performance conclusion | Exploratory observations only; controlled acceptance comparison not established. |
| Orchestration/Astra outcome | Not evaluated. |
| Deployment/release | Not established by this case note. |

Future consumers should use the [plan](templates/product-validation-plan.md) and [run](templates/product-validation-run.md) templates before relying on similar evidence for task completion.
