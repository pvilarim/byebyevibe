## Why

O hub já tem README EN e posicionamento “from vibe coding to agentic engineering”, mas o **nome público** continua genérico (“SDD Install Kit”) e o **slug do repo** é `gitnexus-graphify-openspec` — SEO fraco e identidade frágil vs Spec Kit / OpenSpec (research §11 P10). A explore fechou a marca **ByeByeVibe** com subtítulo canónico, alinhada ao gancho de mercado sem fingir boilerplate.

**Issue:** —

## What Changes

- Adoptar **ByeByeVibe** como display name público (H1 / About / referências de discovery).
- Fixar copy canónica EN no hero do `README.md` raiz:

  ```text
  # ByeByeVibe
  From vibe coding to shippable AI engineering.

  Not another Next.js starter — the SDD control plane
  (OpenSpec + graphs + gates) your repo is missing.
  ```

- Actualizar About sugerido, avaliação P10, `openspec/project.md`, intro de `sdd-kit/README.md`, e ponteiros de discovery no guia / AGENTS — **sem** renomear a pasta `sdd-kit/` (path técnico permanece).
- Documentar **[AÇÃO MANUAL]** para rename do repo GitHub → `byebyevibe` (ou slug aprovado), About/topics, e URLs de autor.
- Adicionar secção curta **Maintainer** no README raiz com LinkedIn + portfólio (links fornecidos pelo operador; placeholders até lá).
- **Não** traduzir o hub inteiro (continua roadmap §11 passo ④). **Não** GIF (P5). **Não** renomear path `sdd-kit/` neste change (**BREAKING** se feito — fora de escopo).

## Capabilities

### New Capabilities

- _(nenhuma)_

### Modified Capabilities

- `sdd-discovery-positioning`: nome público ByeByeVibe + hero/About canónicos; P10 deixa de estar “adiado”; checklist manual de rename GitHub; secção Maintainer (LinkedIn/portfólio) no README raiz.
- `sdd-install-kit`: clarificar dual naming — **marca pública** ByeByeVibe vs **path/payload** `sdd-kit/` (comandos e MANIFEST inalterados).

## Impact

- **Docs/discovery:** `README.md`, `sdd-kit/README.md`, `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`, `doc/avaliacoes/README.md`, `doc/sistema-sdd-pedro.md` (ponteiros first-contact / título onde diga “SDD Install Kit” como marca), `openspec/project.md`, `AGENTS.md` (referências ao hub/nome público; **não** alterar o index GitNexus sem nota).
- **Specs:** deltas em `sdd-discovery-positioning` e `sdd-install-kit`.
- **Código/scripts:** headers/echo opcionais “SDD Install Kit” → “ByeByeVibe (sdd-kit)” só onde for display; **paths e CLI flags intactos**.
- **Consumidores do kit:** zero mudança de comando (`bash sdd-kit/install.sh …`) se a pasta não mudar.
- **GitHub (manual):** Settings → rename repo, Description, Topics, Homepage opcional; actualizar bookmarks/remotes.
- **Fora:** archive histórico, PRs antigos, i18n completa, GIF, Landing/Discord.
