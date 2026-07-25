# Avaliação: Ferramentas OSS para gaps de cobertura do sistema SDD

| Campo | Valor |
|-------|--------|
| **Data** | 2026-07-25 |
| **Avaliador** | Sessão explore `explore-oss-coverage-gaps` (Cloud Agent) |
| **Candidato** | 8 gaps × candidatos OSS — detalhe em [`openspec/changes/explore-oss-coverage-gaps/research.md`](../../openspec/changes/explore-oss-coverage-gaps/research.md) |
| **Decisão** | Misto — ver tabela por item |
| **Escopo** | Extensão do sdd-kit + correcções pontuais ao stack |

## Resumo executivo

Research tipo E identificou 8 gaps na cobertura do sistema SDD para desenvolvimento assistido por IA e avaliou candidatos OSS segundo 5 critérios (instalação, compatibilidade, overlap, adequação ao fluxo explore→propose→apply, confiabilidade/comunidade). Metodologia de inserção padronizada definida em [`metodologia-insercao.md`](../../openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md) (6 fases; piloto dispensável para inserções sem binário/hook novo — excepção aprovada 2026-07-25).

## Decisões por item

| Gap | Candidato | Decisão | Nota |
|-----|-----------|---------|------|
| G1 Enforcement CI | GitHub Actions (workflow próprio) | **Adoptado** (pendente change) | pre-commit/Lefthook **descartados** — overlap com hooks graphify/gitnexus |
| G2 Verificação por testes | [TDD Guard](https://github.com/nizos/tdd-guard) | **Adoptado** (pendente change; módulo opcional APP) | Piloto obrigatório: empilhamento PreToolUse + custo LLM |
| G3 Feedback de runtime | GlitchTip / Sentry + MCP | **Adiado** — módulo sob demanda | Infra por projecto de produção, não payload de kit |
| G4 Métricas do framework | Apache DevLake | **Adiado** | Correcção manual (`sdd-metrics.sh`) preferida; DevLake se equipe/DORA justificar |
| G5 Rastreabilidade issues | [github-mcp-server](https://github.com/github/github-mcp-server) | **Adoptado** (pendente change) | + campo Issue no template de proposal |
| G6 Multi-agente distribuído | Vibe Kanban / Claude Squad | **Descartado** | Projecto líder órfão (BloopAI encerrou 04/2026); overlap com `sdd-session-*` |
| G7 Review de correctness | [PR-Agent](https://github.com/qodo-ai/pr-agent) | **Adoptado parcial** | Fase 1: skill local `correctness-review`; PR-Agent opcional com pin de versão |
| G8 Supply chain | [Renovate](https://github.com/renovatebot/renovate) + [OSV-Scanner](https://github.com/google/osv-scanner) | **Adoptado** (pendente change) | Templates por perfil no sdd-kit |

## Condições de reavaliação (itens descartados/adiados)

- **Vibe Kanban (G6):** reavaliar em ~6 meses (2027-01) — categoria de orquestradores multi-agente em consolidação; ou se surgir necessidade real de coordenação multi-máquina.
- **DevLake (G4):** reavaliar se os repos de produção ganharem CI/CD + equipe em escala que justifique DORA.
- **GlitchTip/Sentry (G3):** activar sob demanda por projecto de produção; convenção de citar issue do tracker em proposals tipo B já pode ser adoptada sem a infra.

## Referências

- Research completo (fontes, métricas de comunidade, matriz de critérios): `openspec/changes/explore-oss-coverage-gaps/research.md`
- Metodologia de inserção (fases, registro em 6 pontos, matriz de acionamento): `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
- PR: [#21](https://github.com/pvilarim/gitnexus-graphify-openspec/pull/21)
