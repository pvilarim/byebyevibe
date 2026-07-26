## Context

O change `add-sdd-ci-gates-workflow` está em estado de pre-archive. Uma revisão adversarial identificou 6 findings (F-C1-1, F-C1-2, F-NORM-1 a F-NORM-3, F-NORM-6) que devem ser resolvidos antes de o archive ser feito, para garantir que o snapshot ficará correcto e consistente.

## Goals / Non-Goals

**Goals:**
- Remover dead code real (`sdd-kit/install.sh`) sem alterar comportamento
- Sincronizar versão do guia (`v1.3.2` → `v1.4.0`) em todos os pontos de referência
- Promover `specs/sdd-ci-gates/spec.md` para o directório permanente `openspec/specs/`
- Corrigir gate da task 6.2 para verificar o path permanente correcto
- Propagar entradas CI Gates ao template `AGENTS.core.md` (usado em instalações futuras)
- Actualizar referências de versão em `AGENTS.md` e timestamp em `openspec/infra.md`

**Non-Goals:**
- Alterar o comportamento do workflow `sdd-gates.yml`
- Introduzir novas secções no guia `doc/sistema-sdd-pedro.md`
- Modificar qualquer lógica de instalação além da remoção do dead code

## Decisions

**D1 — Remoção cirúrgica do dead code:** O primeiro bloco `python3 - <<'PY'` (linhas 130–160 em `sdd-kit/install.sh`) imprime TSV para stdout sem nenhum consumidor; o segundo bloco (dentro do `while IFS=$'\t' read` process substitution, logo abaixo) é o correcto. A remoção é segura: não afecta qualquer variável, pipe ou side effect.

**D2 — Bump de versão:** O guia passa de `v1.3.2` para `v1.4.0` porque o PR #23 introduz uma feature nova (gates de CI), que justifica o bump minor. As duas ocorrências a actualizar são: cabeçalho (linha 5) e prompt §2.0 (linha 149).

**D3 — Promoção da spec:** `openspec/specs/` é o directório canónico para specs activas; o directório `openspec/changes/<id>/specs/` é temporário, de trabalho. A promoção é feita por cópia; o ficheiro original permanece no change para rastreabilidade.

**D4 — Gate task 6.2:** O gate original verifica o ficheiro no path do change (`openspec/changes/.../spec.md`), o que é um falso positivo — o ficheiro sempre existe lá. O gate correcto verifica o destino permanente (`openspec/specs/sdd-ci-gates/spec.md`).

**D5 — AGENTS.core.md:** Este template é o ponto de partida para instalações em repos alvo. Sem as entradas CI Gates, os repos instalados ficariam sem referência ao workflow e ao §2.12. A fonte de verdade é o `AGENTS.md` do hub (branch `origin/cursor/add-sdd-ci-gates-workflow-dfec`).

## Risks / Trade-offs

- **Baixo risco:** todos os findings são Tipo A/B; as edições são localizadas e verificáveis por gate.
- **Dependência de ordem:** F-NORM-1 (criar `openspec/specs/sdd-ci-gates/spec.md`) deve ser feito antes da correcção do gate em tasks.md, para que o gate passe ao ser testado localmente.
- **Sem testes automáticos:** este repo é DOCS_SPECS; verificação manual via gates de shell é suficiente.
