## ADDED Requirements

### Requirement: Proportionate semantic acceptance contract

The hub SHALL provide a product-validation protocol and plan/run templates for standard SDD use without Astra. The plan MUST map changed behavior to OpenSpec scenarios, expected observations, applicability, verification method, acceptance criterion and owner. Runtime or UI checks MUST be selected only when relevant; documentation-only work MUST support semantic walkthroughs without a browser. Results MUST distinguish pass, fail, not run and not applicable with justification. Structural checks alone MUST NOT establish semantic acceptance.

#### Scenario: Green build with missing images
- **WHEN** structural gates pass but a required image-loading scenario fails
- **THEN** the semantic result is fail and the affected task remains incomplete.

#### Scenario: Documentation-only change
- **WHEN** a change has no runtime or UI behavior
- **THEN** the plan uses applicable document scenarios and records runtime checks as not applicable without introducing a browser dependency.

### Requirement: Durable revision-bound run evidence

Run records MUST identify the plan, repository, base revision, tested revision or dirty-content hashes, time, environment, commands or manual procedure, expected and observed outcomes, failures, exclusions, reviewer and evidence locations. Attempts MUST have unique IDs and retain previous results; corrections MUST identify superseded records. Evidence MUST be reviewable through durable safe receipts and accessible raw-artifact references where retained. Missing or inaccessible material MUST be disclosed. Changes after validation MUST cause affected checks to be repeated or evidence reuse to be explicitly justified by unchanged scope.

#### Scenario: Source changed after successful test
- **WHEN** a subsequent edit affects the previously tested behavior
- **THEN** the earlier run remains recorded but does not prove acceptance of the new revision until affected checks pass again.

#### Scenario: Failed run followed by success
- **WHEN** a failed asset-loading attempt is followed by a successful attempt
- **THEN** both attempts and exclusion reasons remain identifiable rather than replacing the failure with the success.

#### Scenario: Raw artifacts unavailable
- **WHEN** an old temporary screenshot or measurement cannot be recovered
- **THEN** the report records the evidence gap and limits the claim instead of fabricating or implying a retained observation.

### Requirement: Performance claims have declared measurement boundaries

Prospective performance acceptance comparisons MUST declare metrics and units, baseline and candidate identity, target/tolerance, relevant environment, warm-up, sample duration, repetition/stopping policy, randomness/seed, cache and run-order policy before collection. Records MUST preserve attempt-level observations and distinguish exploratory measurements from registered comparisons. CPU time, GPU time, draw calls and frame pacing MUST NOT be treated as interchangeable metrics. Headless/visible mode and emulated/physical device context MUST be labeled separately. Missing measurements MUST make the corresponding conclusion inconclusive.

#### Scenario: Single exploratory headless sample
- **WHEN** a prototype has one short headless sample without prior thresholds or controlled ordering
- **THEN** it can be reported as an observation with limitations but not as a statistically established or retrospectively pre-registered acceptance result.

#### Scenario: Reduced draw calls with long frames
- **WHEN** draw calls decrease but long frames remain and GPU time is unmeasured
- **THEN** the report states the draw-call result and frame observations separately and makes no unsupported GPU or stutter-free claim.

### Requirement: Tool readiness and equivalent verification are explicit

Validation records MUST describe required tool availability, index freshness when consulted, failures, selected fallback and uncovered scope using the existing tooling-guidance cascade. No specific browser, host, API, GitHub, Graphify or GitNexus installation SHALL become a new mandatory dependency through this protocol. When an equivalent method does not establish a required observation, dependent acceptance MUST remain not run or blocked.

#### Scenario: Automated browser unavailable
- **WHEN** browser automation cannot run
- **THEN** an evidenced equivalent manual check can establish its covered scenarios, or the unmet scenarios remain not run; the agent does not assume success or silently install tooling.

### Requirement: Product and orchestration outcomes remain separate

Evidence MUST distinguish product behavior, human visual acceptance, performance conclusions and orchestration evaluation. Product acceptance MUST NOT retrospectively admit an Astra trial or establish its hypotheses. Astra claims require their separately authorized protocol, configuration, budgets and comparisons. This capability MUST preserve OpenSpec authority, explicit human approval, separate phases, local worktree coordination and the standard workflow without Astra. It MUST NOT activate Astra, migrate old releases, adopt a dashboard as truth or configure production model routing.

#### Scenario: User approves portfolio appearance
- **WHEN** the operator accepts a prototype visually without an admitted orchestration experiment
- **THEN** the visual acceptance is recorded for its revision and orchestration remains not evaluated.

#### Scenario: Standard consumer without Astra
- **WHEN** a consumer selects the product-validation templates without Astra
- **THEN** it can use the standard SDD phases and its own verification tools without installing an orchestration runtime or migrating its release.
