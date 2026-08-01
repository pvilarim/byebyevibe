## ADDED Requirements

### Requirement: Infra status reflects actual package installation

After `--apply`, the Probity Module section written to `openspec/infra.md` MUST distinguish the npm package row from the config row: the `@nizos/probity` row SHALL be marked installed (✅) only when the package was actually installed (present in `package.json` devDependencies or resolvable), and SHALL be marked `pending` when the npm install step was skipped or declined. The verify command listed for the package row MUST check the package itself (e.g. resolve/`npm ls`), not the presence of `probity.config.ts`.

#### Scenario: Declined npm install yields pending package status

- **WHEN** the operator runs `--apply` without `--yes` and declines the npm install prompt (or no TTY is available)
- **THEN** `openspec/infra.md` shows the `@nizos/probity` row as `pending` while the `probity.config.ts` row may show ✅, and the package row's verify command checks the package, not the config file

#### Scenario: Completed npm install yields installed status

- **WHEN** the operator runs `--apply --yes` and `npm install -D @nizos/probity@<pin>` succeeds
- **THEN** `openspec/infra.md` shows the `@nizos/probity` row as ✅
