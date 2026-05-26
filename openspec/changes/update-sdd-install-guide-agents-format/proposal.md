# Proposal — Actualizar guia SDD v1.1 e formato AGENTS.md

## Porquê

O guia `doc/sistema-sdd-pedro.md` é o artefacto usado para instalar o sistema (OpenSpec + GitNexus + Graphify) em **qualquer** repositório. A v1.0 descrevia o fluxo mas não definia de forma operacional:

- Formato alvo do `AGENTS.md` alinhado a [agents.md](https://agents.md/) e ao workshop TLC
- Anti-padrões (não gerar AGENTS com IA, não duplicar blocos GitNexus)
- Perfis de repo (APP vs DOCS_SPECS)
- Checklist pós-instalação (§2.8)

O piloto `spec-pedro` expôs drift: `AGENTS.md` com ~186 linhas e bloco GitNexus duplicado.

## O quê

1. Actualizar `doc/sistema-sdd-pedro.md` para **v1.1.0** (§2.0, §2.5 expandido, §2.8, templates 12.2a/b/12.7, changelog).
2. Aplicar template **12.2b** (perfil DOCS_SPECS) no repo piloto.
3. `AGENTS.md` aninhado em `doc/curso/scripts/`.
4. Cross-ref em `openspec/project.md`.

## Escopo

- Documentação e harness de agentes — **sem** novo comportamento de aplicação.
- Não adoptar YAML AAIF, não remover `.cursor/rules/*.mdc`.

## Sucesso

- Checklist §2.8 do guia passa no `spec-pedro`.
- Próxima instalação noutro repo segue só o guia v1.1 sem repetir erros do piloto.
