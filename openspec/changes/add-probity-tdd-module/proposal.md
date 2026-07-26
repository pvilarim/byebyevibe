## Why

O gap G2 (`explore-oss-coverage-gaps/research.md`) identifica que a regra R6 — "teste que falha primeiro, depois fix" — existe em `AGENTS.md` e no guia SDD mas não tem enforcement in-session: agentes marcam tasks como concluídas e aplicam fixes sem regressão coberta. O candidato original era TDD Guard; o maintainer declarou-o superseded por **Probity** ([nizos/probity](https://github.com/nizos/probity)) — novos projectos devem adoptar Probity; TDD Guard mantido só para legado ([tdd-guard README](https://github.com/nizos/tdd-guard)). Este change propõe o módulo opcional G2 com Probity, seguindo o precedente C1-UI e a metodologia de inserção (Fases 0–3), com piloto obrigatório antes de promover ao MANIFEST.

## What Changes

- Novo módulo opcional **APP/HYBRID** via `sdd-kit/install-probity-module.sh` (`--detect` → `--apply [--yes]`), análogo a `install-ui-module.sh`
- Pacote `@nizos/probity@1.10.0` (devDependency no repo APP) com `probity.config.ts` template e regra `enforceTdd()` para materializar R6
- Mecanismo **modo B** (PreToolUse hook) — único gap in-band no stack SDD; empilha com GitNexus + Graphify (piloto mede latência p95 e falsos positivos)
- Substituição documental **TDD Guard → Probity** em toda a documentação SDD que cita G2 (lista canónica em `tasks.md` § doc migration)
- Registro nos 6 pontos do contrato (`infra.md`, `AGENTS.md`, skill opcional, guia §2.16, avaliação G2, sdd-kit/MANIFEST)
- Actualização da pipeline de reviews: `testes (R6/Probity enforceTdd)` → `correctness-review` → `simplify-review` → …
- Nova spec `sdd-probity-module`; delta em `sdd-correctness-review` (posição na pipeline)
- Nota histórica: "TDD Guard superseded por Probity (2026-07)" — não re-propor TDD Guard

## Capabilities

### New Capabilities

- `sdd-probity-module`: Módulo opcional pós-C1 que instala Probity, template `probity.config.ts`, script `install-probity-module.sh`, registo em `infra.md`, e requisitos normativos para repos APP/HYBRID com testes (Vitest/pytest)

### Modified Capabilities

- `sdd-correctness-review`: Actualizar requisito de posição na pipeline — "R6/TDD Guard" → "R6/Probity (enforceTdd)"

## Impact

- **Novos ficheiros (apply):** `sdd-kit/install-probity-module.sh`, `sdd-kit/templates/install-probity-module.sh`, `sdd-kit/templates/probity.config.ts`, `doc/design/004-probity-module-install.md` (opcional), `openspec/specs/sdd-probity-module/spec.md`
- **Modificados (apply):** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`, `doc/avaliacoes/README.md`, `openspec/changes/explore-oss-coverage-gaps/research.md`, `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`, `doc/sistema-sdd-pedro.md` (nova §2.16), `AGENTS.md`, `sdd-kit/templates/AGENTS.core.md`, `openspec/infra.md` + template, `sdd-kit/README.md`, `sdd-kit/MANIFEST.yaml`, `.claude/skills/correctness-review/SKILL.md`, `.cursor/skills/correctness-review/SKILL.md`, `openspec/specs/sdd-correctness-review/spec.md`
- **Dependência externa:** `@nizos/probity@1.10.0` (MIT) — devDependency no repo APP; sem API key Probity (reusa sessão do agente)
- **Perfis:** APP e HYBRID com testes — activo; DOCS_SPECS — SKIP (este hub)
- **Piloto obrigatório:** worktree APP com Vitest ou pytest antes de bump MANIFEST; critérios quantificados em `design.md`
- **Non-goals:** TDD Guard no kit; Probity obrigatório em DOCS_SPECS; substituir CI (`sdd-gates`); lint integration automática (documentar gap opcional)
