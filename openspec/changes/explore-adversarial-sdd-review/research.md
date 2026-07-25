# Revisão Adversarial — Sistema SDD Completo

> **Fase:** Explore · **Data:** 2026-07-25  
> **Branch auditada:** `cursor/add-sdd-ci-gates-workflow-dfec` (pré-archive de `add-sdd-ci-gates-workflow`, PR #23)  
> **Método:** 5 subagentes em paralelo, contexto limpo, lentes independentes  
> **Escopo:** Read-only — nenhum ficheiro foi alterado fora de `openspec/changes/explore-adversarial-sdd-review/`

---

## Sumário executivo

| Lente | 🔴 Crítico | 🟡 Significativo | 🟢 Baixo | Total |
|-------|-----------|-----------------|----------|-------|
| C1 — Instalador greenfield | 3 | 4 | 3 | 10 |
| C2 — Upgrade 1.3.x → 1.4.0 | 4 | 6 | 0 | 10 |
| Coerência normativa | 2 | 4 | 0 | 6 |
| Grey areas operacionais | 0 | 6 | 2 | 8 |
| Segurança | 2 | 5 | 2 | 9 |
| **Total** | **11** | **25** | **7** | **43** |

**Achados críticos que requerem ação antes do archive:**

1. **F-C1-1** — Dead code imprime TSV bruto no stdout do `install.sh`
2. **F-C1-2** — Versão do guia inconsistente em três locais do próprio documento
3. **F-C1-3** — `bootstrap-sdd.sh` não está no MANIFEST; C1 greenfield não tem entry point
4. **F-C2-1** — `--dry-run --apply` combinados anulam silenciosamente o `--dry-run`
5. **F-C2-3** — `sdd-upgrade-diff.sh` omite silenciosamente o diff de `AGENTS.md`
6. **F-C2-4** — `--apply` sobrescreve `.github/workflows/` sem backup nem confirmação
7. **F-C2-6** — `--apply` sem dry-run prévio não tem enforcement; UPGRADE_REPORT não é verificado
8. **F-NORM-1** — Spec `sdd-ci-gates` não promovida para `openspec/specs/`
9. **F-NORM-2** — Template `AGENTS.core.md` não recebeu actualizações de CI Gates
10. **F-SEC-1** — Path traversal via `path:` do MANIFEST em `install.sh` / `upgrade.sh`
11. **F-SEC-2** — Telemetria PostHog ativa por defeito; `OPENSPEC_TELEMETRY: "0"` sem documentação

---

## Lente 1 — Instalador C1 (greenfield)

### F-C1-1: Dead code imprime TSV bruto no stdout durante instalação
**Severidade:** 🔴  
**Evidência:** `sdd-kit/install.sh:130–160` — bloco `python3 - <<'PY' "$MANIFEST" "$PROFILE" "$KIT_DIR"` corre e imprime para stdout, mas o `while IFS=$'\t' read` na linha 162 não consome esse output; lê de um processo separado via `< <(python3 - <<'PY' "$MANIFEST" "$PROFILE"` linha 168).  
**Problema:** O primeiro bloco Python é dead code operacional. Em qualquer execução (incluindo `--dry-run`), o utilizador vê ~30 linhas de TSV bruto (`templates/scripts/verify-infra.sh\tscripts/verify-infra.sh\tCOPY`) antes das mensagens `COPY/NEW/KEEP`. O output parece erros ou junk e obscurece o log real de instalação.  
**Correcção proposta:** Remover o primeiro bloco Python inteiramente (linhas 130–160). Toda a lógica operacional está correctamente no segundo bloco (linhas 168–194).

---

### F-C1-2: Versão do guia inconsistente em três locais do mesmo ficheiro
**Severidade:** 🔴  
**Evidência:** `doc/sistema-sdd-pedro.md:5` — `> **Guia canónico de instalação (v1.3.2)**`; `doc/sistema-sdd-pedro.md:149` — prompt IA diz `v1.3.0`; `doc/sistema-sdd-pedro.md:20` — `Versão do guia: 1.4.0`; changelog `### 1.4.0 (2026-07-25)`.  
**Problema:** O blockquote no topo (primeira coisa que um agente de IA lê) diz `v1.3.2`. O prompt de instalação assistida em §2.0 diz `v1.3.0`. O corpo e o changelog dizem `1.4.0`. Um agente que parseia a versão do guia para verificar paridade com o MANIFEST (`guide_version: "1.4.0"`) reportará discrepância.  
**Correcção proposta:** Actualizar linha 5 para `v1.4.0` e linha 149 para `v1.4.0`.

---

### F-C1-3: `bootstrap-sdd.sh` não está no MANIFEST — C1 greenfield sem entry point instalável
**Severidade:** 🔴  
**Evidência:** `sdd-kit/MANIFEST.yaml` — sem entrada para `scripts/bootstrap-sdd.sh`; `sdd-kit/README.md` — cenário C1: `bash scripts/bootstrap-sdd.sh`; `doc/sistema-sdd-pedro.md:154` — prompt §2.0 instrui `bash scripts/bootstrap-sdd.sh`.  
**Problema:** Um utilizador que clona um repo vazio e segue §2.1 → C1 → README não encontra o ficheiro: está em `sdd-kit/templates/scripts/bootstrap-sdd.sh` no hub, mas não é copiado pelo `install.sh` para o repo alvo. O caminho correcto seria `bash sdd-kit/templates/scripts/bootstrap-sdd.sh` mas nunca é dito.  
**Correcção proposta:** Adicionar entrada no MANIFEST para `scripts/bootstrap-sdd.sh` com `merge: COPY` e `profiles: [APP, DOCS_SPECS, HYBRID]`, ou corrigir o README/guide para indicar `bash sdd-kit/templates/scripts/bootstrap-sdd.sh`.

---

### F-C1-4: Filtro HYBRID no primeiro bloco Python diverge do bloco operativo
**Severidade:** 🟡  
**Evidência:** `sdd-kit/install.sh:157` — `if profile not in profiles and profile != "HYBRID": continue`; `sdd-kit/install.sh:191` — `if profile not in profiles: continue`.  
**Problema:** O primeiro bloco (dead code, F-C1-1) usa lógica diferente: para `HYBRID`, `and profile != "HYBRID"` é sempre `False`, tornando a condição sempre `False` → nunca filtra nada para HYBRID. O segundo bloco (operativo) filtra correctamente por `profile not in profiles`. Confusão garantida ao debugar.  
**Correcção proposta:** Remover o primeiro bloco (F-C1-1). Se mantido, alinhar para `if profile not in profiles: continue`.

---

### F-C1-5: §2.8 checklist não tem item para `.github/workflows/sdd-gates.yml`
**Severidade:** 🟡  
**Evidência:** `doc/sistema-sdd-pedro.md:381–399` — 18 itens de checklist, nenhum menciona o workflow de CI; `sdd-kit/MANIFEST.yaml` — `.github/workflows/sdd-gates.yml` com `merge: COPY`, `profiles: [APP, DOCS_SPECS, HYBRID]`.  
**Problema:** O ficheiro `sdd-gates.yml` é instalado para todos os perfis mas a checklist de verificação pós-instalação não tem nenhum item que confirme a sua presença. Um utilizador que completa §2.8 não tem sinal de que o gate de CI foi instalado correctamente.  
**Correcção proposta:** Adicionar a §2.8: `- [ ] .github/workflows/sdd-gates.yml presente (ver §2.12 para branch protection manual)`.

---

### F-C1-6: Branch protection manual está desligada do fluxo C1
**Severidade:** 🟡  
**Evidência:** `doc/sistema-sdd-pedro.md:11` — tabela C1: `§2.1 → CLIs → bash sdd-kit/install.sh → §2.8`; `doc/sistema-sdd-pedro.md:468` — branch protection em §2.12, sem referência no fluxo C1.  
**Problema:** Um utilizador que segue o fluxo C1 canónico instala `sdd-gates.yml` mas nunca lê §2.12. O gate fica instalado e silenciosamente inoperante: corre no Actions mas não bloqueia merge sem branch protection. O `[AÇÃO MANUAL NECESSÁRIA]` em §2.12 nunca é visto no fluxo de instalação padrão.  
**Correcção proposta:** Actualizar a tabela C1 para incluir `→ §2.12 (branch protection)` após §2.8, ou adicionar ao §2.8 um item de checklist que aponte explicitamente para §2.12.

---

### F-C1-7: §2.1 "Ordem importa" não menciona `sdd-kit/install.sh`
**Severidade:** 🟡  
**Evidência:** `doc/sistema-sdd-pedro.md:133–140` — diagrama da ordem: `1. OpenSpec → 2. GitNexus → 3. Graphify → 4. Curar AGENTS.md → 5. IDEs` — sem passo para `install.sh`.  
**Problema:** §2.1 é o mapa de referência para a ordem. Um utilizador humano que o lê como guia sequencial não vê onde `bash sdd-kit/install.sh` se encaixa. O script instala ficheiros curados que devem existir antes de "Curar AGENTS.md" (passo 4), mas não aparece na ordem.  
**Correcção proposta:** Adicionar ao diagrama: `1. OpenSpec → 2. GitNexus → 3. Graphify → 3b. sdd-kit/install.sh → 4. Curar AGENTS.md → 5. IDEs`.

---

### F-C1-8: `bootstrap-sdd.sh` auto-detecção de perfil não suporta HYBRID
**Severidade:** 🟡  
**Evidência:** `sdd-kit/templates/scripts/bootstrap-sdd.sh:25–31` — lógica: `PROFILE="APP"` se `package.json` existe, else `PROFILE="DOCS_SPECS"`. Sem branch para HYBRID.  
**Problema:** Um repo HYBRID nunca é auto-detectado — o utilizador instala o perfil errado sem aviso.  
**Correcção proposta:** Adicionar detecção de HYBRID (ex.: presença de `package.json` + `openspec/` juntos), ou emitir aviso explícito pedindo ao utilizador para confirmar o perfil.

---

### F-C1-9: `gate:` no MANIFEST nunca é avaliada pelo instalador nem pelo `verify.sh`
**Severidade:** 🟢  
**Evidência:** `sdd-kit/install.sh:185` — segundo bloco Python parseia apenas `path`, `source`, `merge` (sem `gate`); `sdd-kit/verify.sh` — sem referência a `gate:` do MANIFEST.  
**Problema:** Os valores de `gate:` são metadata decorativa. Nenhuma automação os executa. A presença cria expectativa de verificação automatizada que não existe.  
**Correcção proposta:** Documentar em `MANIFEST.yaml` (comentário) que `gate:` é metadata humana não avaliada pelo install/verify. Ou implementar avaliação no `verify.sh`.

---

### F-C1-10: `chmod` duplicado em `apply_file()` — segunda condição é superconjunto
**Severidade:** 🟢  
**Evidência:** `sdd-kit/install.sh:82–87` — dois blocos chmod: `[[ "$dest" == scripts/*.sh || "$dest" == */*.sh ]]` e `[[ "$dest" == *.sh ]]`.  
**Problema:** Em bash `[[ ]]`, `*.sh` corresponde a qualquer string que termine em `.sh`, incluindo `scripts/foo.sh`. O segundo bloco cobre todos os casos do primeiro. O primeiro bloco é completamente redundante.  
**Correcção proposta:** Remover as linhas 82–84; manter apenas `if [[ "$dest" == *.sh ]]; then chmod +x...`.

---

## Lente 2 — Upgrade C2 (1.3.x → 1.4.0)

### F-C2-1: `--dry-run --apply` combinados ignoram silenciosamente o `--dry-run`
**Severidade:** 🔴  
**Evidência:** `sdd-kit/upgrade.sh:46` — `$APPLY || DRY_RUN=true`; `sdd-kit/upgrade.sh:108` — `if $DRY_RUN && ! $APPLY`.  
**Problema:** Quando o operador passa `--dry-run --apply` (tentando ver o que vai acontecer antes de aplicar), o `--dry-run` é silenciosamente anulado. O script aplica directamente. A armadilha é real e contraintuitiva: `--dry-run` implica segurança, mas é um no-op combinado com `--apply`.  
**Correcção proposta:** `if $DRY_RUN && $APPLY; then echo "ERROR: --dry-run e --apply são exclusivos" >&2; exit 2; fi`.

---

### F-C2-2: Header impresso sempre como "(dry-run)" mesmo em modo `--apply`
**Severidade:** 🟡  
**Evidência:** `sdd-kit/upgrade.sh:52` — `echo "=== SDD UPGRADE REPORT (dry-run) ==="` (incondicional).  
**Problema:** Um operador que corre `--apply` vê no stdout `=== SDD UPGRADE REPORT (dry-run) ===` e pode concluir erroneamente que nada foi aplicado.  
**Correcção proposta:** `$DRY_RUN && echo "=== SDD UPGRADE REPORT (dry-run) ===" || echo "=== SDD UPGRADE APPLY ==="`.

---

### F-C2-3: `sdd-upgrade-diff.sh` silencia completamente o diff de `AGENTS.md`
**Severidade:** 🔴  
**Evidência:** `sdd-kit/MANIFEST.yaml` — `path: AGENTS.md`, `source: templates/AGENTS.core.md`; `sdd-kit/templates/scripts/sdd-upgrade-diff.sh:106-112`.  
**Problema:** O script constrói `CURATED_FILES` com os paths de destino do MANIFEST. Para `AGENTS.md`, faz lookup em `$STAGING_DIR/AGENTS.md`. Quando `STAGING_DIR=sdd-kit/templates/`, o ficheiro real é `sdd-kit/templates/AGENTS.core.md` — não `AGENTS.md`. O fallback também não existe. Resultado: a condição `[[ ! -f "$staging" ]]` executa `continue` — o diff de `AGENTS.md` é **completamente omitido sem nenhum aviso**. O script reporta "Nenhuma diferença" para o ficheiro mais crítico do SDD.  
**Correcção proposta:** O parser de `CURATED_FILES` deve extrair também o campo `source` do MANIFEST e usá-lo directamente como path de staging em vez de assumir que dest == basename do template.

---

### F-C2-4: `--apply` sobrescreve `.github/workflows/sdd-gates.yml` sem backup nem confirmação
**Severidade:** 🔴  
**Evidência:** `sdd-kit/MANIFEST.yaml` — `.github/workflows/sdd-gates.yml`, `merge: COPY`; `sdd-kit/upgrade.sh:152-157` — `cp "$KIT_DIR/$src" "$REPO_ROOT/$dest"` incondicional.  
**Problema:** Um operador que customizou o workflow perde todas as customizações com um único `--apply`. Não há gate interactivo, não há `cp --backup`, e não há verificação de que o UPGRADE_REPORT foi aprovado antes do apply.  
**Correcção proposta:** Antes de `cp`, emitir `diff` do ficheiro existente vs template para stderr e exigir flag `--force` para ficheiros que diferem; ou criar backup automático `$dest.bak.$(date +%s)`.

---

### F-C2-5: `--apply` dispara para todos os perfis — ignora campo `profiles` do MANIFEST
**Severidade:** 🟡  
**Evidência:** `sdd-kit/MANIFEST.yaml` — `.cursor/rules/010-typescript.mdc` com `profiles: [APP, HYBRID]`; `sdd-kit/upgrade.sh:162-172` — parser Python extrai apenas `source`, `merge`, `path` (não `profiles`).  
**Problema:** Um repo `DOCS_SPECS` que corre `--apply` vai receber `010-typescript.mdc` e `030-supabase.mdc` sobrescritos com os templates, mesmo que o MANIFEST declare que só se aplicam a APP e HYBRID.  
**Correcção proposta:** Adicionar `--profile APP|DOCS_SPECS|HYBRID` ao `upgrade.sh` e filtrar entradas do MANIFEST antes de classificar e aplicar.

---

### F-C2-6: `--apply` sem dry-run prévio não tem enforcement — UPGRADE_REPORT não é verificado
**Severidade:** 🔴  
**Evidência:** `sdd-kit/upgrade.sh:107-136` — scaffold do UPGRADE_REPORT dentro de `if $DRY_RUN && ! $APPLY`; `sdd-kit/upgrade.sh:143` — bloco de apply sem verificação de relatório existente.  
**Problema:** O workflow documentado exige "aprovação humana do UPGRADE_REPORT.md antes de `--apply`". Mas nada impede correr directamente `--apply`. O scaffold do relatório é saltado e o apply acontece imediatamente sem registo auditável.  
**Correcção proposta:** No início do bloco `if $APPLY`, verificar se `$REPORT_FILE` existe e contém `[x] Actualização aprovada`; abortar com erro explicativo se não.

---

### F-C2-7: `scripts/sdd-upgrade-diff.sh` é sobrescrito pelo próprio `--apply`
**Severidade:** 🟡  
**Evidência:** `sdd-kit/MANIFEST.yaml` — `scripts/sdd-upgrade-diff.sh`, `merge: COPY`; `sdd-kit/upgrade.sh:152-157`.  
**Problema:** O script de diff usado para review antes do apply está listado com `merge: COPY` — ao rodar `--apply`, o próprio `sdd-upgrade-diff.sh` é sobrescrito. Customizações locais são perdidas sem aviso.  
**Correcção proposta:** Mudar `merge` de `sdd-upgrade-diff.sh` para `MERGE` no MANIFEST, ou emitir aviso antes de sobrescrever ferramentas de upgrade.

---

### F-C2-8: §2.9.3 (prompt IA) instrui criação de branch; `upgrade.sh` não cria nem verifica
**Severidade:** 🟡  
**Evidência:** `doc/sistema-sdd-pedro.md:530` — "1. Criar branch `chore/upgrade-sdd-VERSÃO_ALVO`"; `sdd-kit/upgrade.sh` — nenhuma referência a `git branch`.  
**Problema:** O prompt de upgrade assistido define como passo 1 a criação de uma branch de isolamento. O `upgrade.sh` não cria branch, não verifica se está em `main`, e não emite aviso. Um operador que corra `--apply` directamente opera em `main` sem protecção.  
**Correcção proposta:** Adicionar ao início de `--apply`: verificar `git branch --show-current` e rejeitar (ou avisar em vermelho) se estiver em `main`/`master` sem `--force`.

---

### F-C2-9: Rollback de upgrade C2 sem procedimento documentado concreto
**Severidade:** 🟡  
**Evidência:** `doc/sistema-sdd-pedro.md:671` — "Backups `/tmp/*.backup` ou branch permitem rollback" (vago); ausência de `git restore <files>` documentado.  
**Problema:** O único rollback explícito (§2.12) é para o gate de CI — apagar o workflow. Para um upgrade C2 completo que sobrescreveu múltiplos ficheiros COPY, o rollback é "a branch permite rollback" sem comandos concretos. Se o operador não criou branch (F-C2-8), não há rollback possível.  
**Correcção proposta:** O bloco de apply deve gerar `APPLY_MANIFEST.txt` com lista e checksums dos ficheiros copiados. O §2.9 deve documentar `git restore --source=HEAD~1 <file>` como rollback explícito.

---

### F-C2-10: Rótulo `APPLY_TEMPLATE` no dry-run diverge da semântica real do `--apply`
**Severidade:** 🟡  
**Evidência:** `sdd-kit/upgrade.sh:76` — `COPY) echo "APPLY_TEMPLATE $dest"`; `sdd-kit/upgrade.sh:150` — `[[ "$merge" == "COPY" ]] || continue`.  
**Problema:** O dry-run mostra `APPLY_TEMPLATE`, sugerindo que existe uma estratégia de merge chamada `APPLY_TEMPLATE`. Não existe — é apenas um rótulo de display para ficheiros com `merge: COPY`. Um operador avançado que adicione `merge: APPLY_TEMPLATE` no MANIFEST verá o ficheiro classificado como `MERGE` e nunca aplicado.  
**Correcção proposta:** Usar `COPY` no output do classify (em vez de `APPLY_TEMPLATE`), ou introduzir `APPLY_TEMPLATE` como valor real de merge com semântica documentada.

---

## Lente 3 — Coerência normativa

### F-NORM-1: Spec `sdd-ci-gates` não promovida para `openspec/specs/`
**Severidade:** 🔴  
**Evidência:** `openspec/changes/add-sdd-ci-gates-workflow/tasks.md:linha 6.2` — marcada `[x]` com gate `test -f openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md`; `openspec/specs/` — sem diretório `sdd-ci-gates/`.  
**Problema:** A task 6.2 foi marcada como concluída com base num gate que só verifica existência do spec **dentro do diretório changes/**, não a promoção para `openspec/specs/`. A capability `sdd-ci-gates` não tem spec canônica — diferente de todas as outras capabilities. O gate foi escrito de forma a passar sem executar a tarefa real.  
**Correcção proposta:** Criar `openspec/specs/sdd-ci-gates/spec.md` com os requisitos do delta spec. Corrigir o gate da task 6.2 para `test -f openspec/specs/sdd-ci-gates/spec.md`.

---

### F-NORM-2: Template `AGENTS.core.md` não recebeu actualizações de CI Gates
**Severidade:** 🔴  
**Evidência:** `sdd-kit/templates/AGENTS.core.md` — sem entrada "Gates de CI" na tabela "Contexto sob demanda"; sem secção "CI Gates (sdd-gates)" em Integrações (compare com `AGENTS.md:124`); `AGENTS.core.md` tem 107 linhas; `AGENTS.md` do hub tem 167.  
**Problema:** A task 5.2 tinha gate `grep -qi 'sdd-gates\|Gates de CI\|CI Gates' AGENTS.md` — verificou apenas o `AGENTS.md` do hub, nunca o template distribuído. O MANIFEST declara `AGENTS.md` com `merge: MERGE_PROFILE` e `source: templates/AGENTS.core.md`. Qualquer repo consumidor que instalar o kit v1.4.0 receberá o `AGENTS.core.md` como base — sem o registro de CI Gates.  
**Correcção proposta:** Actualizar `sdd-kit/templates/AGENTS.core.md` com: (1) entrada "Gates de CI (sdd-gates, operação)" em "Contexto sob demanda"; (2) bloco "CI Gates (sdd-gates)" em Integrações; (3) linha `npx openspec validate --all --strict` em Commands.

---

### F-NORM-3: `AGENTS.md` do hub referencia guia como `v1.3` quando kit/guia estão em `1.4.0`
**Severidade:** 🟡  
**Evidência:** `AGENTS.md:50` — `| Guia de instalação SDD (v1.3) | doc/sistema-sdd-pedro.md |`; `AGENTS.md:79` — `doc/sistema-sdd-pedro.md §2.11 (v1.3.1)`; `sdd-kit/MANIFEST.yaml` — `version: "1.4.0"`, `guide_version: "1.4.0"`.  
**Problema:** Três documentos normativos (MANIFEST, project.md, infra.md) dizem 1.4.0. O `AGENTS.md` do hub ainda diz v1.3 e v1.3.1 em dois locais distintos.  
**Correcção proposta:** Actualizar linha 50 para `(v1.4.0)` e linha 79 para `(v1.4.0)`.

---

### F-NORM-4: Package name diverge entre documentação e workflow real
**Severidade:** 🟡  
**Evidência:** `AGENTS.md:24` — `npx openspec validate --all --strict`; `.github/workflows/sdd-gates.yml` — `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict --no-interactive`.  
**Problema:** O AGENTS.md documenta `npx openspec` (sem scope, sem versão pinada, sem `--no-interactive`) como "mesmo comando do workflow". O workflow usa `@fission-ai/openspec@1.3.1` (scopado, versão pinada). `npx openspec` e `npx @fission-ai/openspec` podem resolver pacotes diferentes.  
**Correcção proposta:** Alinhar o AGENTS.md: `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`. Idem no `AGENTS.core.md`.

---

### F-NORM-5: Decisão D4 (verify-infra.sh em modo tolerante) sem cobertura de spec
**Severidade:** 🟡  
**Evidência:** `design.md` — secção "Tratamento do verify-infra.sh no CI (D4)" descreve comportamento crítico; `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md` — nenhum dos 4 requisitos cobre a política de `continue-on-error`.  
**Problema:** A decisão D4 é normativa — define que `sdd-kit/verify.sh` é report-only. Sem spec formal, uma refactorização futura pode inadvertidamente tornar este passo bloqueante sem violar nenhum requisito escrito.  
**Correcção proposta:** Adicionar ao spec: `"Requirement: verify-infra.sh runs report-only — O passo sdd-kit/verify.sh DEVE correr com continue-on-error porque verify-infra.sh reporta FAIL para CLIs ausentes no runner; NUNCA deve bloquear merge."` com cenário correspondente.

---

### F-NORM-6: `openspec/infra.md` com timestamp stale >30 dias violando a própria regra
**Severidade:** 🟡  
**Evidência:** `openspec/infra.md:2` — `> Última verificação: 2026-06-17`; hoje é 2026-07-25 (38 dias); `openspec/infra.md` (secção "Regra agentes") — `"Stale: se verificação >30 dias, tratar como [STALE >30d]"`.  
**Problema:** O change adicionou a secção "CI Gates" ao infra.md mas não actualizou o timestamp. Qualquer agente que leia o infra.md deve, pela sua própria regra, tratar o documento inteiro como `[STALE >30d]`, inclusive as novas entradas de CI Gates.  
**Correcção proposta:** Actualizar o timestamp para 2026-07-25 ou correr `bash scripts/verify-infra.sh` para actualização automática antes de fechar o change.

---

## Lente 4 — Grey areas operacionais

### F-OPS-1: Rule 016 aplica "MUST" absoluto sem excepção para runners de CI
**Severidade:** 🟡  
**Evidência:** `.cursor/rules/016-session-coordination.mdc` — `alwaysApply: true` + "Apply MUST correr `scripts/sdd-session-register.sh` [...] antes de editar ficheiros"; `.github/workflows/sdd-gates.yml` — nenhuma chamada a scripts de sessão.  
**Problema:** A rule tem `alwaysApply: true` e usa "MUST" sem carve-out para ambientes CI. O design D8 explica que R3 (skill/rule) é N/A para o workflow, mas não aborda R11 (coordenação de sessões). Um agente que revise conformidade da regra pode questionar a ausência dos scripts de registro, ou tentar chamá-los num runner efêmero onde `.sdd/runtime/` não persiste.  
**Correcção proposta:** Adicionar à rule 016: "**Excepção CI:** runners efêmeros (e.g. GitHub Actions) estão isentos de R11 — `.sdd/runtime/` é gitignored e não persiste entre runs; a coordenação de sessões aplica-se apenas a máquinas locais com estado persistente."

---

### F-OPS-2: Skip de `verify-task-patterns.sh` baseado em existência de ficheiro, não em perfil — mensagem enganosa
**Severidade:** 🟡  
**Evidência:** `.github/workflows/sdd-gates.yml:41-45` — `if [[ -f scripts/verify-task-patterns.sh ]]; then ... else echo "SKIP: ... (APP profile)" fi`; `sdd-kit/MANIFEST.yaml` — `verify-task-patterns.sh` com `profiles: [DOCS_SPECS, HYBRID]`.  
**Problema:** A lógica de skip é puramente `test -f` — agnóstica a perfil. A mensagem "SKIP ... (APP profile)" é uma assunção falsa: um repo DOCS_SPECS ou HYBRID que tenha perdido o script por deleção acidental saltará silenciosamente um gate **bloqueante** com uma mensagem que sugere comportamento esperado de perfil APP.  
**Correcção proposta:** Substituir a mensagem por `echo "SKIP: scripts/verify-task-patterns.sh not found (install via sdd-kit if profile is DOCS_SPECS/HYBRID)"` — ou, para detecção de perfil real, ler `openspec/project.md` no workflow.

---

### F-OPS-3: `verify.sh` chama `sdd-session-status.sh` em CI — check semanticamente nulo e com FAIL contável por ausência
**Severidade:** 🟡  
**Evidência:** `sdd-kit/verify.sh:44-48` — `run_check "sdd-session-status.sh" bash ...`; `.gitignore` — `.sdd/runtime/`.  
**Problema:** Em CI, `.sdd/runtime/sessions/` não existe (gitignored). O check é trivialmente verdadeiro num runner efêmero e nunca fornece sinal útil. Pior: se `scripts/sdd-session-status.sh` não estiver instalado, `FAILURES++` é incrementado mas o step tem `continue-on-error: true`, então o FAIL é absorvido sem que o operador saiba que um script de sessão (não relacionado a CI) é o motivo.  
**Correcção proposta:** Em `verify.sh`, envolver o check de sessão com guarda de ambiente: `if [[ -z "${CI:-}" ]]; then run_check ...; fi`. Ou mover o check de sessão para script separado invocado apenas localmente.

---

### F-OPS-4: `install.sh` copia `.github/workflows/sdd-gates.yml` para repos não-GitHub sem aviso
**Severidade:** 🟡  
**Evidência:** `sdd-kit/install.sh` — nenhuma verificação de plataforma; `sdd-kit/MANIFEST.yaml` — entry `.github/workflows/sdd-gates.yml` com `profiles: [APP, DOCS_SPECS, HYBRID]` sem condição de plataforma; `verify.sh:51-52` — `run_check "sdd-gates workflow" test -f "$REPO_ROOT/.github/workflows/sdd-gates.yml"`.  
**Problema:** Para um operador em GitLab CI, Gitea ou Azure DevOps: (1) `install.sh` copia silenciosamente o workflow GitHub Actions; (2) `verify.sh` valida com `test -f` → ✅; (3) `openspec/infra.md` fica com "CI Gates: ✅" apesar do gate nunca ter corrido. Falsa segurança total.  
**Correcção proposta:** Em `install.sh`, ao copiar `.github/workflows/`, emitir `WARN: .github/workflows/sdd-gates.yml é GitHub Actions — adaptar manualmente para GitLab CI, Gitea, ou Azure DevOps` se `GITLAB_CI`, `GITEA_ACTIONS` etc. estiverem no ambiente.

---

### F-OPS-5: `OPENSPEC_TELEMETRY: "0"` sem decisão documentada, sem fonte, sem impacto de remoção
**Severidade:** 🟡  
**Evidência:** `.github/workflows/sdd-gates.yml:17` — `OPENSPEC_TELEMETRY: "0"`; `design.md` tabela Decisions D1–D11 — sem menção à variável; AGENTS.md, infra.md, §2.12 — sem menção.  
**Problema:** A variável existe sem nenhuma decisão D-N associada, nenhuma referência a fonte que explique o que controla, e nenhuma documentação de que operadores devem incluí-la ao adaptar o workflow. Um operador que adapte para GitLab não sabe se esta linha é crítica para privacidade ou defensiva-por-precaução.  
**Correcção proposta:** Adicionar decisão D12 no design.md explicando o que `OPENSPEC_TELEMETRY=0` desactiva e para quem. Adicionar comentário inline no workflow: `# Disable CLI telemetry`.

---

### F-OPS-6: Pin do CI em `min_openspec` (1.3.1) com kit em 1.4.0 — paridade de validação quebrada
**Severidade:** 🟡  
**Evidência:** `sdd-kit/MANIFEST.yaml` — `min_openspec: "1.3.1"`, `version: "1.4.0"`; `.github/workflows/sdd-gates.yml:38` — `npx --yes @fission-ai/openspec@1.3.1 validate`.  
**Problema:** O CI valida com 1.3.1 mas o kit e o guia estão em 1.4.0. Se entre 1.3.1 e 1.4.0 foram adicionadas regras de `--strict`, specs que as violam passarão no CI mas falharão na validação local com a versão actual. Paridade CI/local quebrada.  
**Correcção proposta:** Pinar o CI na versão do kit (`@1.4.0`). Documentar que `min_openspec` é o mínimo para instalar, não para pinar no CI.

---

### F-OPS-7: Restore de `infra.md` silencia falha de checkout sem consequência real mas mascarável
**Severidade:** 🟢  
**Evidência:** `.github/workflows/sdd-gates.yml:57-59` — `run: git checkout -- openspec/infra.md 2>/dev/null || true`.  
**Problema:** Se `openspec/infra.md` não estiver rastreado no git, o `git checkout --` falha silenciosamente. Em runners efêmeros a consequência prática é nula, mas o silêncio dificulta diagnóstico.  
**Correcção proposta:** Adicionar comentário no step: `# No-op if openspec/infra.md is untracked (new install) — runner is ephemeral`.

---

### F-OPS-8: Design rejeita "hooks" sem distinguir git hooks de Claude Code PreToolUse hooks
**Severidade:** 🟢  
**Evidência:** `design.md` — "Alternativo A rejeitado [...] overlap com hooks existentes (graphify/gitnexus)"; `doc/sistema-sdd-pedro.md §10.5` — `.claude/hooks/block-dangerous.sh` são PreToolUse hooks (Claude Code, não git hooks).  
**Problema:** Os "hooks existentes" de graphify são git hooks de rebuild; `.claude/hooks/` são Claude Code PreToolUse hooks — mecanismos completamente distintos. Não há sobreposição real. Um futuro revisor pode interpretar erroneamente que `.claude/hooks/` cobrem o gate de CI.  
**Correcção proposta:** Refinar no design.md: "Rejeitado: git hooks contornáveis (`--no-verify`); `.claude/hooks/` (PreToolUse Claude Code) são ortogonais — não conflitam nem cobrem o gate de servidor."

---

## Lente 5 — Segurança

### F-SEC-1: Path traversal via `path:` do MANIFEST — `install.sh` e `upgrade.sh`
**Severidade:** 🔴  
**Evidência:** `sdd-kit/install.sh:47` — `local dest_path="$REPO_ROOT/$dest"`; `sdd-kit/upgrade.sh:152-153` — `cp "$KIT_DIR/$src" "$REPO_ROOT/$dest"`.  
**Problema:** O campo `path:` do MANIFEST é lido pelo Python inline e emitido sem validação. Um MANIFEST comprometido com `path: ../../.bashrc` resulta em `$REPO_ROOT/../../.bashrc` — fora do repo. O `install.sh` aplica `chmod +x` após o `cp`, agravando a escalada.  
**Correcção proposta:**
```bash
dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
[[ "$dest_path" == "$REPO_ROOT"/* ]] || { echo "ERROR: path traversal blocked: $dest" >&2; exit 1; }
```

---

### F-SEC-2: Telemetria PostHog ativa por defeito — exfiltração implícita sem documentação
**Severidade:** 🔴  
**Evidência:** `.github/workflows/sdd-gates.yml:14` — `OPENSPEC_TELEMETRY: "0"`; dependência `posthog-node@^5.20.0` em `@fission-ai/openspec@1.3.1`.  
**Problema:** Sem `OPENSPEC_TELEMETRY: "0"`, o `npx @fission-ai/openspec` envia dados via PostHog. O workflow desactiva no CI, mas desenvolvedores que rodam `npx openspec validate` localmente sem essa env var expõem dados do repo (nomes de changes, paths, metadados) a um servidor externo. Não há documentação em `050-security.mdc` sobre o que é colectado. O `sdd-kit` distribui o workflow para repos consumidores — esses repos precisam saber configurar a variável localmente.  
**Correcção proposta:** (a) Documentar em `050-security.mdc` e `openspec/infra.md` o que o PostHog colecta; (b) adicionar `OPENSPEC_TELEMETRY=0` ao `.env.example` dos repos consumidores; (c) considerar opt-in em vez de opt-out.

---

### F-SEC-3: Supply chain — `npx --yes` sem verificação de integridade (hash)
**Severidade:** 🟡  
**Evidência:** `.github/workflows/sdd-gates.yml:38` — `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict --no-interactive`.  
**Problema:** O pin `@1.3.1` é semver, não hash imutável. Dependências transitivas (`posthog-node@^5.20.0`, `zod@^4.0.17`, `commander@^14.0.0`) usam ranges `^` — não fixadas. Um comprometimento de qualquer dependência transitiva seria executado silenciosamente com acesso ao checkout completo.  
**Correcção proposta:** (a) Usar `npm install --ignore-scripts @fission-ai/openspec@1.3.1` + `npx openspec` com `package-lock.json` commitado; (b) pinar actions por SHA em vez de tag (ver F-SEC-4).

---

### F-SEC-4: Actions GitHub Actions pinadas por tag mutável, não por commit SHA
**Severidade:** 🟡  
**Evidência:** `.github/workflows/sdd-gates.yml:23,27,31` — `uses: actions/checkout@v4`, `uses: actions/setup-node@v4`, `uses: actions/setup-python@v5`.  
**Problema:** Tags mutáveis podem ser movidas por comprometimento do repositório `actions/*`. Um actor malicioso com acesso redirecionaria a tag para código arbitrário com acesso ao checkout. O padrão recomendado pelo GitHub e OpenSSF é pinar por commit SHA imutável.  
**Correcção proposta:**
```yaml
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
```

---

### F-SEC-5: `gate:` no MANIFEST é vetor de injeção futuro — risco arquitetural não documentado
**Severidade:** 🟡  
**Evidência:** `sdd-kit/MANIFEST.yaml` — `gate: "bash scripts/sdd-session-check.sh --phase explore"`; `sdd-kit/install.sh:146` — campo `gate` parseado e armazenado mas não utilizado.  
**Problema:** O campo `gate` é lido e armazenado pelo Python sem uso posterior — código morto que cria confusão. O MANIFEST já contém gates com execução de scripts — se uma versão futura implementar `eval "$gate"`, o MANIFEST torna-se vetor de RCE. Não há aviso ou comentário documentando que `gate:` é metadata não executável.  
**Correcção proposta:** (a) Remover o parse de `gate` do Python do `install.sh` (linha 146); (b) adicionar comentário no MANIFEST: `# gate: metadata documental — NÃO executar via eval`; (c) documentar em `050-security.mdc`.

---

### F-SEC-6: Bloco Python duplicado em `install.sh` — dead code com lógica de filtro divergente e segurança diferente
**Severidade:** 🟡  
**Evidência:** `sdd-kit/install.sh:131-159` — primeiro bloco `python3 - <<'PY'` com saída despejada no terminal; `install.sh:163-196` — segundo bloco dentro de `< <(...)` é o funcional.  
**Problema:** Dead code com semântica incorreta para HYBRID poderia ser "ressuscitado" por um maintainer, causando instalação de ficheiros não esperados. O primeiro bloco tem lógica de filtro que bypassa o perfil HYBRID em vez de o aplicar.  
**Correcção proposta:** Remover o primeiro bloco Python inteiramente (linhas 130-160).

---

### F-SEC-7: `upgrade.sh --apply` sem verificação de integridade do kit — kit comprometido instalado silenciosamente
**Severidade:** 🟡  
**Evidência:** `sdd-kit/upgrade.sh:70` — `diff -q "$REPO_ROOT/$dest" "$src"`; `sdd-kit/upgrade.sh:152-153` — `cp` sem hash check.  
**Problema:** Se o `sdd-kit/` for substituído por um kit comprometido, o `--apply` instalará os ficheiros maliciosos silenciosamente. Não há checksum manifest nem assinatura.  
**Correcção proposta:** Adicionar campo `sha256:` por arquivo no MANIFEST. O `upgrade.sh` verificaria `sha256sum -c` antes de `cp`.

---

### F-SEC-8: Sem `timeout-minutes` no workflow — runner pode ficar ocupado 6 horas
**Severidade:** 🟢  
**Evidência:** `.github/workflows/sdd-gates.yml` — ausência de `timeout-minutes` em qualquer nível.  
**Problema:** GitHub Actions usa timeout padrão de 6 horas. Para um gate que deveria completar em <2 minutos, um `npx` travado (aguardando prompt de rede) pode consumir 6h de minutos faturáveis em repos privados.  
**Correcção proposta:** Adicionar `timeout-minutes: 10` no job `sdd-gates` e `timeout-minutes: 3` nos steps críticos.

---

### F-SEC-9: `050-security.mdc` não cobre riscos introduzidos pelo próprio workflow
**Severidade:** 🟢  
**Evidência:** `.cursor/rules/050-security.mdc` — regras focadas em agentes IA (segredos, `rm -rf`); ausência de regras sobre CI, supply chain, telemetria.  
**Problema:** O workflow foi implementado com comentário `# D11 — menor escopo de token (regra 050)` referenciando a regra, mas a regra não define o que "menor escopo de token" significa para CI. Também não cobre: proibição de `pull_request_target` com secrets, pin SHA para actions, `OPENSPEC_TELEMETRY=0` em CI, validação de paths antes de `cp`.  
**Correcção proposta:** Adicionar secção `## CI/CD` à `050-security.mdc` com regras explícitas para workflows.

---

## Mapa de prioridades para archive/follow-up

```
BLOQUEAR ARCHIVE:
  F-NORM-1  — Spec sdd-ci-gates não promovida para openspec/specs/
  F-NORM-2  — AGENTS.core.md não actualizado para consumers

CORRIGIR ANTES DE MERGE (PR #23):
  F-C1-1    — Dead code TSV no install.sh
  F-C1-2    — Versão do guia inconsistente (linha 5 e 149)
  F-C2-1    — --dry-run --apply anulam-se silenciosamente
  F-C2-3    — sdd-upgrade-diff.sh omite AGENTS.md silenciosamente
  F-C2-4    — --apply sem backup de workflows customizados
  F-C2-6    — --apply sem enforcement de UPGRADE_REPORT aprovado
  F-SEC-1   — Path traversal via MANIFEST
  F-SEC-2   — Telemetria PostHog sem documentação

FOLLOW-UP (próximo change):
  F-C1-3    — bootstrap-sdd.sh no MANIFEST
  F-C1-5    — §2.8 checklist com item de CI gate
  F-C1-6    — Fluxo C1 incluir §2.12
  F-C2-5    — upgrade.sh sem --profile
  F-C2-8    — upgrade.sh verificar branch antes de --apply
  F-NORM-3  — AGENTS.md bump para v1.4.0
  F-NORM-4  — Alinhar comando npx no AGENTS.md
  F-NORM-5  — Spec D4 (verify-infra report-only)
  F-NORM-6  — infra.md timestamp stale
  F-OPS-1   — Rule 016 excepção CI
  F-OPS-2   — Mensagem de skip enganosa no workflow
  F-OPS-3   — sdd-session-status.sh em CI desnecessário
  F-OPS-4   — Aviso para repos não-GitHub
  F-OPS-5   — OPENSPEC_TELEMETRY documentado como D12
  F-OPS-6   — Pin CI na versão do kit, não min_openspec
  F-SEC-3   — Supply chain: lockfile para npx
  F-SEC-4   — Actions pinadas por SHA
  F-SEC-5   — gate: no MANIFEST — risco futuro documentado
  F-SEC-8   — timeout-minutes no workflow
  F-SEC-9   — 050-security.mdc secção CI/CD

INFORMATIVO / BACKLOG:
  F-C1-7, F-C1-8, F-C1-9, F-C1-10
  F-C2-7, F-C2-9, F-C2-10
  F-OPS-7, F-OPS-8
  F-SEC-6, F-SEC-7
```

---

## Fontes consultadas

- `origin/cursor/add-sdd-ci-gates-workflow-dfec:doc/sistema-sdd-pedro.md`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:sdd-kit/install.sh`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:sdd-kit/upgrade.sh`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:sdd-kit/verify.sh`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:sdd-kit/MANIFEST.yaml`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:.github/workflows/sdd-gates.yml`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:sdd-kit/templates/.github/workflows/sdd-gates.yml`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:openspec/changes/add-sdd-ci-gates-workflow/{design,tasks}.md`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:.cursor/rules/016-session-coordination.mdc`
- `origin/cursor/add-sdd-ci-gates-workflow-dfec:openspec/infra.md`
- `openspec/specs/` (listing — branch alvo)
- `sdd-kit/templates/scripts/` (listing — branch alvo)
