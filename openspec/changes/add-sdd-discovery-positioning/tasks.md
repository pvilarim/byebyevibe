# Tasks — add-sdd-discovery-positioning

> Escopo apply após aprovação (R7). Perfil **DOCS_SPECS** — só docs/specs neste hub. **Non-goals:** app boilerplate, GIF/Pages/Discord/rename (P5–P10). **Issue:** —

## 1. Avaliação canónica (documento de partida)

- [ ] 1.1 Criar `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` a partir de `openspec/changes/add-sdd-discovery-positioning/research.md` (estrutura TEMPLATE + conteúdo da análise; estados: superfícies P0/P1 Adoptado após apply; P5–P10 Adiado; app scaffold Non-goal)
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Invariants:** `sdd-discovery-positioning` — Competitive evaluation document is the lasting research artifact
  - **Gate:** `test -f doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'vibe coding' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'spec-kit\|Spec Kit' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`

- [ ] 1.2 Indexar a avaliação em `doc/avaliacoes/README.md` (nova linha na tabela; decisão **Misto** ou **Adoptado** conforme texto)
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Gate:** `grep -q '2026-07-26-sdd-discovery-positioning' doc/avaliacoes/README.md`

## 2. README raiz (discovery EN)

- [ ] 2.1 Criar `README.md` na raiz: hero from-vibe-to-agentic; anti-boilerplate; CTA `sdd-kit/install.sh`; demo opsx; overview OpenSpec/GitNexus/Graphify/gates/módulos; compare resumido; link guia pt-BR; checklist About/topics ou ponteiro à avaliação
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Invariants:** `sdd-discovery-positioning` — Root README exists with vibe-to-agentic positioning; Root README includes demo and capability overview; Positioning forbids pretending to be an app starter
  - **Gate:** `test -f README.md && grep -qiE 'vibe coding|agentic' README.md && grep -qiE 'not another|boilerplate|starter' README.md && grep -q 'sdd-kit/install.sh' README.md && grep -qiE 'opsx|OpenSpec' README.md && grep -qi 'GitNexus' README.md && grep -qi 'Graphify' README.md`

## 3. Kit README (posicionamento + mapa amigável)

- [ ] 3.1 Prepend/intro em `sdd-kit/README.md`: o que é o kit; mapa C1/C2/C3 (e G2/G4 se couber) → nomes humanos; link ao README raiz / guia; preservar tabelas e comandos operacionais existentes
  - **Pattern:** `sdd-kit/README.md`
  - **Invariants:** `sdd-install-kit` — Kit README includes discovery positioning for newcomers
  - **Gate:** `grep -qiE 'vibe|newcomer|first contact|posicionamento|what this is' sdd-kit/README.md && grep -qE 'C1|Instalação|Greenfield|primeira vez' sdd-kit/README.md && grep -q 'install.sh' sdd-kit/README.md && grep -q 'APP' sdd-kit/README.md`

## 4. Quickstart no guia canónico

- [ ] 4.1 Adicionar secção curta de first-contact / vibe-coder em `doc/sistema-sdd-pedro.md` (apontar README raiz + `install.sh --dry-run`); ligar em “Como usar este documento” ou índice; nota no Changelog
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-discovery-positioning` — First-contact quickstart in the canonical guide
  - **Gate:** `grep -qiE 'vibe|first.contact|primeiro contacto|quickstart' doc/sistema-sdd-pedro.md && grep -q 'README.md' doc/sistema-sdd-pedro.md`

## 5. Cross-refs e acção manual

- [ ] 5.1 Actualizar `openspec/project.md` Cross-references (ponteiro à avaliação e/ou README raiz); opcional ≤5 linhas em `AGENTS.md` Contexto sob demanda se couber sem inchar
  - **Pattern:** `openspec/project.md`
  - **Gate:** `grep -q '2026-07-26-sdd-discovery-positioning\|discovery-positioning\|README.md' openspec/project.md`

- [ ] 5.2 Garantir checklist `[AÇÃO MANUAL NECESSÁRIA]` com About sugerido + topics (`vibe-coding`, `spec-driven-development`, `context-engineering`, `claude-code`, `cursor`) na avaliação e/ou README
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Invariants:** `sdd-discovery-positioning` — Manual GitHub About and topics checklist
  - **Gate:** `grep -q 'AÇÃO MANUAL NECESSÁRIA' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'AÇÃO MANUAL NECESSÁRIA' README.md && grep -q 'vibe-coding' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`

## 6. Specs — promoção (no archive / fim do apply)

- [ ] 6.1 Promover `openspec/changes/add-sdd-discovery-positioning/specs/sdd-discovery-positioning/spec.md` → `openspec/specs/sdd-discovery-positioning/spec.md`
  - **Pattern:** `openspec/specs/sdd-metrics/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-discovery-positioning/spec.md`

- [ ] 6.2 Aplicar delta ADDED de `sdd-install-kit` em `openspec/specs/sdd-install-kit/spec.md`
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `grep -qi 'discovery positioning\|Kit README includes discovery' openspec/specs/sdd-install-kit/spec.md`

## 7. Validação

- [ ] 7.1 `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-discovery-positioning --strict` e `bash scripts/verify-task-patterns.sh`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-discovery-positioning --strict && bash scripts/verify-task-patterns.sh`
