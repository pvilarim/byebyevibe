## ADDED Requirements

### Requirement: CI exercises a greenfield install

The `sdd-gates` workflow MUST perform a C1 greenfield install into a repository created empty within the run, and MUST fail when that install does not succeed. The target MUST NOT be the hub checkout and MUST NOT be seeded with directories the install is expected to create.

The check MUST assert more than the installer's exit code. It MUST assert that a non-trivial number of files was written, and MUST assert the presence of at least one installed file whose parent directory did not exist in the empty target — because a path guard that requires pre-existing parents fails precisely there, and an exit code alone did not catch that defect.

This gate is required because every other gate in the workflow runs against the hub, which already carries the directory layout a greenfield target lacks. A defect fatal to every genuine first install therefore remained invisible to CI.

#### Scenario: Greenfield install succeeds

- **WHEN** the workflow creates an empty repository, places the documented install footprint in it, and runs the installer
- **THEN** the installer exits zero, files are written, and the job passes

#### Scenario: Zero-file install fails the job

- **WHEN** the installer exits zero but writes no files into the empty target
- **THEN** the job fails, because the file-count assertion is not satisfied by the exit code alone

#### Scenario: A newly created parent directory is exercised

- **WHEN** the greenfield assertion runs
- **THEN** it verifies at least one installed file that lives under a directory absent from the empty target before the install
