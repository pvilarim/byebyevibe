# Design — Correcções remanescentes da revisão adversarial SDD

> Fonte: `openspec/changes/explore-adversarial-sdd-review/research.md` (2026-07-25)  
> Classificação: Tipo A/B — sem novo comportamento externo, sem nova dependência

## Context

A revisão adversarial identificou 43 findings; 32 foram resolvidos em 5 changes anteriores (mergeados). Este change endereça os 9 findings restantes 🟡/🟢 que estavam no BACKLOG/INFORMATIVO sem change associado.

**Nota:** F-C1-9 (comentário `gate:` no MANIFEST) foi resolvido no change anterior — o MANIFEST.yaml já contém o comentário bilíngue extenso nas linhas 2–13. Este change não inclui F-C1-9.

**Ficheiros afectados:**
- `sdd-kit/upgrade.sh` (F-C2-2, F-C2-10)
- `sdd-kit/MANIFEST.yaml` (F-C2-7)
- `sdd-kit/install.sh` (F-C1-10)
- `sdd-kit/templates/scripts/bootstrap-sdd.sh` (F-C1-8)
- `doc/sistema-sdd-pedro.md` §2.1 e §2.9.7 (F-C1-7, F-C2-9)
- `.github/workflows/sdd-gates.yml` + `sdd-kit/templates/.github/workflows/sdd-gates.yml` (F-OPS-7)
- `openspec/changes/add-sdd-ci-gates-workflow/design.md` (F-OPS-8)

## Goals / Non-Goals

**Goals:**
- Corrigir output enganoso do `upgrade.sh` (F-C2-2, F-C2-10)
- Preservar customizações locais do `sdd-upgrade-diff.sh` em `--apply` (F-C2-7)
- Remover dead code de chmod em `install.sh` (F-C1-10)
- Adicionar aviso de perfil HYBRID ao `bootstrap-sdd.sh` (F-C1-8)
- Completar documentação de ordem de instalação em §2.1 (F-C1-7)
- Documentar rollback concreto em §2.9 (F-C2-9)
- Clarificar semântica do `|| true` no workflow (F-OPS-7)
- Distinguir git hooks de Claude Code hooks no design.md existente (F-OPS-8)

**Non-Goals:**
- F-SEC-7 (kit integrity check) — requer exploração de design separada; deferido
- Qualquer mudança de comportamento funcional — correcções de saída e documentação apenas
- Introduzir novo estado persistente, nova flag de CLI ou nova dependência

## Decisions

### D1 — Header condicional em `upgrade.sh` (F-C2-2)

**Problema:** Linha 75 imprime `=== SDD UPGRADE REPORT (dry-run) ===` mesmo em modo `--apply`, criando confusão ao operador que pode concluir que nada foi aplicado.

**Fix:** Substituir por condicional:
```bash
$DRY_RUN && echo "=== SDD UPGRADE REPORT (dry-run) ===" || echo "=== SDD UPGRADE APPLY ==="
```

A verificação de exclusividade `--dry-run + --apply` já existe (linhas 53–56 do upgrade.sh), portanto apenas um dos ramos será atingido.

### D2 — Rótulo `APPLY_TEMPLATE` → `COPY` no classify (F-C2-10)

**Problema:** A função `classify()` imprime `APPLY_TEMPLATE` para entradas com `merge: COPY`. O campo MANIFEST usa `COPY` como valor — o rótulo divergente cria expectativa falsa de que `APPLY_TEMPLATE` é uma estratégia de merge reconhecida.

**Fix:** Alterar linha 99 de `COPY) echo "APPLY_TEMPLATE ${prefix}$dest" ;;` para `COPY) echo "COPY           ${prefix}$dest" ;;`.

Padding com espaços para alinhar com `KEEP_LOCAL   ` (13 chars) e manter output legível em colunas.

### D3 — `sdd-upgrade-diff.sh` muda para `merge: MERGE` (F-C2-7)

**Problema:** O script de diff usado para review pré-upgrade está marcado com `merge: COPY` — ao correr `--apply`, o próprio `sdd-upgrade-diff.sh` é sobrescrito, perdendo customizações locais.

**Fix:** Alterar `merge: COPY` para `merge: MERGE` na entrada de `scripts/sdd-upgrade-diff.sh` no MANIFEST.

**Implicação:** O `upgrade.sh --apply` passará a classificar `sdd-upgrade-diff.sh` como `MERGE` (não `COPY`), preservando versão local se diferente do template. O operador recebe aviso de revisão manual como para qualquer ficheiro MERGE.

### D4 — Remoção de `chmod` redundante em `install.sh` (F-C1-10)

**Problema:** `apply_file()` tem dois blocos consecutivos de `chmod`:
- Bloco 1 (linhas 95–97): `[[ "$dest" == scripts/*.sh || "$dest" == */*.sh ]]`
- Bloco 2 (linhas 98–100): `[[ "$dest" == *.sh ]]`

Em bash, `*.sh` casa com qualquer string terminada em `.sh`, incluindo `scripts/foo.sh`. Bloco 1 é um subconjunto estrito de Bloco 2. **Remover Bloco 1** (linhas 95–97) sem alterar resultado funcional.

### D5 — Aviso HYBRID em `bootstrap-sdd.sh` (F-C1-8)

**Problema:** Auto-detecção de perfil testa apenas `package.json` (APP) vs ausência (DOCS_SPECS). Um repo HYBRID (com ambos `package.json` + `openspec/`) nunca é detectado — instala perfil errado silenciosamente.

**Fix:** Adicionar ramo de detecção HYBRID entre o teste existente de APP e DOCS_SPECS:
```bash
if [[ -f "$REPO/package.json" ]] && [[ -d "$REPO/openspec" ]]; then
  echo "WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID." >&2
  echo "      Confirmar: relançar com --profile HYBRID ou DOCS_SPECS se não for APP." >&2
  echo "      A continuar com --profile APP por defeito (passar 'APP', 'DOCS_SPECS' ou 'HYBRID' como 1º argumento)." >&2
  PROFILE="APP"
elif [[ -f "$REPO/package.json" ]]; then
  PROFILE="APP"
else
  PROFILE="DOCS_SPECS"
fi
```

O script já aceita `$1` como caminho de repo — a detecção mantém compatibilidade.

### D6 — Diagrama §2.1 inclui `sdd-kit/install.sh` (F-C1-7)

**Problema:** O diagrama de ordem em §2.1 não menciona `sdd-kit/install.sh`, que é passo crítico entre Graphify e "Curar AGENTS.md".

**Fix:** Actualizar a linha do diagrama para:
```
1. OpenSpec → 2. GitNexus → 3. Graphify → 3b. sdd-kit/install.sh → 4. Curar AGENTS.md → 5. Configurar IDEs
```

### D7 — Rollback explícito em §2.9.7 (F-C2-9)

**Problema:** §2.9.7 diz "Backups `/tmp/*.backup` ou branch permitem rollback" sem commandos concretos. Se o operador não criou branch de isolamento, não há rollback documentado.

**Fix:** Substituir a linha vaga por duas linhas:
```markdown
- [ ] Backups `.bak.*` gerados pelo `--apply` ou branch de isolamento permitem rollback
      `git restore --source=HEAD~1 <ficheiro>` para rollback por ficheiro; `git reset --hard HEAD~1` para reverter commit inteiro
```

### D8 — Comentário no step `Restore infra.md` (F-OPS-7)

**Problema:** `git checkout -- openspec/infra.md 2>/dev/null || true` silencia falha sem explicação. Em diagnóstico, dificulta perceber se o passo teve efeito.

**Fix:** Adicionar comentário inline na linha do `run:`:
```yaml
run: git checkout -- openspec/infra.md 2>/dev/null || true  # No-op if untracked (new install) — runner is ephemeral
```

Aplicar em ambos: workflow live (`.github/workflows/sdd-gates.yml`) e template (`sdd-kit/templates/.github/workflows/sdd-gates.yml`).

### D9 — Distinção git hooks vs Claude Code hooks em design.md (F-OPS-8)

**Problema:** A alternativa A rejeitada em `add-sdd-ci-gates-workflow/design.md` diz "overlap com hooks existentes (graphify/gitnexus)" sem distinguir os dois tipos:
- **git hooks** (graphify/gitnexus): rebuild triggers via `.git/hooks/` — contornáveis com `--no-verify`
- **`.claude/hooks/`**: PreToolUse hooks do Claude Code — mecanismo ortogonal, não relacionado

Um futuro revisor pode interpretar erroneamente que `.claude/hooks/` cobrem o gate de CI.

**Fix:** Expandir a nota de rejeição da alternativa A para clarificar explicitamente:
> "Rejeitado: git hooks contornáveis (`--no-verify`); `.claude/hooks/` (PreToolUse Claude Code) são ortogonais — não conflitam nem cobrem o gate de servidor."

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| D3 (MERGE para sdd-upgrade-diff.sh): repos com versão local muito divergente podem acumular debt de merge | O comportamento `MERGE` é consistente com outros scripts curados do SDD; o operador já está familiarizado com o fluxo de revisão |
| D5 (aviso HYBRID): repos APP legítimos com `openspec/` inicializado receberão o aviso | O aviso é não-bloqueante (`echo ... >&2`); a instalação prossegue com APP por defeito sem interrupção |
| D7 (rollback): `git reset --hard HEAD~1` descarta commits não relacionados se o upgrade não foi isolado em branch | A documentação menciona explicitamente o pré-requisito da branch de isolamento (§2.9.3 passo 1) |

## Migration Plan

Todas as mudanças são retrocompatíveis:
- Scripts existentes: comportamento funcional inalterado
- MANIFEST: consumidores que já têm `sdd-upgrade-diff.sh` local e o customizaram beneficiam imediatamente
- Workflows: comentário apenas, sem alteração de lógica
- Guia: adições documentais apenas

Nenhum rollback de migração necessário.

## Open Questions

_(nenhuma — todos os fixes são determinísticos e sem ambiguidade de design)_
