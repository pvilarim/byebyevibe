# Design — Verificação de integridade do kit SDD

> Fonte: `openspec/changes/explore-adversarial-sdd-review/research.md` §F-SEC-7  
> Deferidor: `openspec/changes/fix-sdd-remaining-fixes/design.md` Non-Goals  
> Classificação: Tipo B/C — novo campo no MANIFEST + verificação em scripts existentes

## Context

O `sdd-kit/` é o payload de distribuição do SDD: contém scripts de sessão, regras Cursor, workflows de CI e o guia de instalação. Quando um operador corre `bash sdd-kit/install.sh` (C1 greenfield) ou `bash sdd-kit/upgrade.sh --apply` (C2 upgrade), os ficheiros em `sdd-kit/templates/` são copiados para o repo alvo sem nenhuma verificação de integridade.

**Superfície de ataque (F-SEC-7):** se `sdd-kit/` for substituído por um kit comprometido — seja por ataque supply chain ao repo de distribuição, seja por edição local acidental —, os ficheiros maliciosos são instalados silenciosamente. Não há checksum manifest nem assinatura.

**Estado actual:** `upgrade.sh --apply` linhas 209–253 iteram os ficheiros `COPY` e fazem `cp "$KIT_DIR/$src" "$REPO_ROOT/$dest"` sem verificar o hash de `$src`. `install.sh` tem o mesmo padrão em `apply_file()`.

## Goals / Non-Goals

**Goals:**
- Adicionar campo `sha256:` por entrada no MANIFEST para cada ficheiro de template
- `upgrade.sh --apply` e `install.sh` (apply path) verificam sha256 antes de `cp`
- `verify.sh` valida paridade entre checksums do MANIFEST e templates actuais no hub
- Script de manutenção `gen-manifest-checksums.sh` para regenerar checksums ao editar templates

**Non-Goals:**
- Assinatura criptográfica do kit inteiro (GPG/sigstore) — escopo separado, dependência externa
- Verificação de integridade em repos consumidores (os consumidores não têm `sdd-kit/templates/`) 
- Verificação de ficheiros já instalados no repo alvo vs template após instalação
- Integração com npm lockfile ou supply chain do `@fission-ai/openspec` (F-SEC-3 — escopo separado)

## Decisions

### D1 — Localização dos checksums: campo `sha256:` inline no MANIFEST.yaml

**Problema:** onde armazenar os checksums?

**Alternativas consideradas:**
- A) Ficheiro separado `sdd-kit/CHECKSUMS.sha256` (formato nativo de `sha256sum -c`) — simples de verificar com `sha256sum -c`, mas cria nova dependência de ficheiro, adiciona passo de sincronização com MANIFEST.
- B) Campo `sha256:` por entrada no MANIFEST.yaml — fonte única de verdade; colocação junto ao `source:` torna óbvio qual ficheiro é verificado; consistente com campos `gate:` existentes.

**Decisão: B** — MANIFEST é a única fonte de verdade para metadados do kit. Não introduz novo ficheiro de estado. O parser Python existente em `upgrade.sh` e `install.sh` já lê os outros campos; adicionar `sha256` é extensão natural.

**Formato:**
```yaml
- path: scripts/verify-infra.sh
  source: templates/scripts/verify-infra.sh
  merge: COPY
  profiles: [APP, DOCS_SPECS, HYBRID]
  sha256: "a3f1..."   # sha256 do ficheiro templates/scripts/verify-infra.sh
  gate: "test -x scripts/verify-infra.sh"
```

### D2 — Geração de checksums: script helper `sdd-kit/gen-manifest-checksums.sh`

**Problema:** os checksums precisam de ser gerados e mantidos actualizados quando templates mudam.

**Alternativas consideradas:**
- CI gera e commita automaticamente — requer write access ao repo em CI, maior complexidade de workflow.
- Manual com `sha256sum` linha a linha — error-prone; o maintainer tem de lembrar de actualizar cada entrada.
- **Script helper:** `sdd-kit/gen-manifest-checksums.sh` lê o MANIFEST, computa `sha256sum` de cada `source:` e faz `sed`/`python` in-place para actualizar (ou inserir) o campo `sha256:`. O maintainer corre uma vez antes de commitar nova versão.

**Decisão: Script helper** — simples, determinístico, verificável. Nenhuma dependência nova (usa apenas `sha256sum` + Python que já estão presentes). Não é instalado em repos consumidores (não tem entrada no MANIFEST).

**Nota:** `sha256sum` está disponível em Linux (coreutils). Em macOS usa-se `shasum -a 256` — o script detecta automaticamente (`command -v sha256sum || shasum -a 256`).

### D3 — Comportamento quando campo `sha256:` está ausente vs diverge

**Dois casos distintos:**

| Situação | Comportamento | Rationale |
|----------|---------------|-----------|
| Campo ausente no MANIFEST | WARN + continuar | Compatibilidade com MANIFESTs antigos ou parcialmente migrados; não é evidência de tamper |
| Campo presente mas hash diverge | ERROR + abort | Evidência de tamper ou edição não autorizada do template; sempre é erro grave |

**Decisão:** Warn-if-absent, error-if-mismatch. Esta política permite rollout gradual (verificar apenas os ficheiros críticos primeiro) e mantém compatibilidade com kits anteriores que não têm `sha256:`.

**Alternativa rejeitada:** error-if-absent — mais seguro mas quebra retrocompatibilidade; considerado após todos os campos sha256 forem preenchidos no MANIFEST 1.4.0 (possível reconsiderar em 1.5.0).

### D4 — Escopo: install.sh e upgrade.sh (não só upgrade.sh)

O finding F-SEC-7 menciona especificamente `upgrade.sh --apply`, mas `install.sh` tem o mesmo padrão de `cp` sem verificação. O custo de implementar nos dois é baixo (mesma lógica, mesma chamada ao parser Python). Não implementar em `install.sh` deixaria C1 (greenfield) vulnerável enquanto C2 ficaria protegido — inconsistência injustificada.

**Decisão:** Verificar integridade em ambos `install.sh` e `upgrade.sh --apply`.

### D5 — verify.sh: parity check no hub

`sdd-kit/verify.sh` corre no hub (onde `sdd-kit/templates/` está presente) e em repos consumidores (onde `sdd-kit/` pode não existir). O check de paridade só faz sentido no hub.

**Decisão:** Adicionar `run_check "kit-integrity (hub only)" ...` condicional: `if [[ -d "$KIT_DIR/templates" ]] && command -v sha256sum &>/dev/null`. Em repos consumidores sem `templates/`, o check é silenciosamente skipped. O script Python de verificação compara sha256 de cada template file contra o campo do MANIFEST — exit 0 se todos passam, exit 1 se qualquer falhar.

### D6 — Implementação do check inline no loop de apply

Para não duplicar lógica entre `install.sh` e `upgrade.sh`, o check é implementado inline nos dois loops (os loops já são estruturalmente independentes — não há função partilhada). O check é 4 linhas:

```bash
if [[ -n "$sha256" ]]; then
  actual="$(sha256sum "$KIT_DIR/$src" 2>/dev/null | cut -d' ' -f1)"
  [[ "$sha256" == "$actual" ]] || { echo "ERROR: integrity check failed: $src (expected $sha256, got $actual)" >&2; exit 1; }
fi
```

A detecção macOS (`shasum -a 256` vs `sha256sum`) é encapsulada numa função `_sha256()` definida no início de cada script para evitar duplicação inline.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Maintainer edita template mas esquece de correr `gen-manifest-checksums.sh` → upgrade.sh aborta com erro de integridade | `gen-manifest-checksums.sh` imprime reminder no final; `verify.sh` detecta divergência no hub antes de push; o erro é autoexplicativo |
| `sha256sum` ausente em ambiente exótico (Alpine sem coreutils) → check silenciosamente skipped | `_sha256()` usa `sha256sum` ou `shasum -a 256`; se ambos ausentes emite WARN explícito e retorna string vazia → policy D3 (warn-if-absent) |
| MANIFEST crescimento em bytes (26 linhas de sha256 × 65 chars ≈ 1.7 KB) | Negligível; MANIFEST já tem ~180 linhas |
| Repos consumidores antigos com MANIFEST sem `sha256:` não são afectados | D3 garante: `upgrade.sh` WARN + continua quando campo ausente; impacto zero para quem não actualizou o MANIFEST |

## Migration Plan

1. Correr `sdd-kit/gen-manifest-checksums.sh` para popular todos os campos `sha256:` no MANIFEST.
2. Commit do MANIFEST actualizado + scripts modificados + `gen-manifest-checksums.sh`.
3. Bump de versão do kit (1.4.0 → mantém; os checksums são metadados de manutenção, não novo comportamento de instalação).
4. Documentar em `AGENTS.md` (hub): "Ao editar qualquer ficheiro em `sdd-kit/templates/`, correr `bash sdd-kit/gen-manifest-checksums.sh` antes de commitar."
5. Repos consumidores: nenhuma acção necessária — o check é no hub; `upgrade.sh` com campo ausente faz WARN (D3).

## Open Questions

_(nenhuma — todas as decisões são determinísticas)_
