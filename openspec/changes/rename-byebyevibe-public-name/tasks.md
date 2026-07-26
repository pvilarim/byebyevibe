> Escopo apply (R7). Perfil **DOCS_SPECS**. Marca: **ByeByeVibe**. Path `sdd-kit/` **não** renomear. Hero EN canónico (design D1–D2). Maintainer: LinkedIn `https://www.linkedin.com/in/pedrovilarim/` · Portfolio `https://pedrocodeart.netlify.app/` (D4). **Issue:** —

## 1. Root README — marca + hero

- [x] 1.1 Substituir H1 e abrir hero com ByeByeVibe + tagline + anti-boilerplate canónicos (design D1); manter CTA `sdd-kit/install.sh`
  - **Gate:** `grep -q '^# ByeByeVibe' README.md && grep -qi 'shippable AI engineering' README.md && grep -qiE 'Not another Next.js|control plane' README.md && grep -q 'sdd-kit/install.sh' README.md`
  - **Pattern:** `README.md`

- [x] 1.2 Adicionar glossário dual naming (ByeByeVibe = public name; `sdd-kit/` = payload) e actualizar blurb About no checklist manual do README
  - **Gate:** `grep -qi 'sdd-kit/' README.md && grep -qi 'ByeByeVibe' README.md && grep -q 'AÇÃO MANUAL' README.md && grep -qi 'byebyevibe\|About' README.md`
  - **Pattern:** `README.md`

- [x] 1.3 Secção Maintainer no fundo com LinkedIn + portfólio canónicos (design D4 / Q1)
  - **Gate:** `grep -qiE 'Maintainer|Author' README.md && grep -q 'linkedin.com/in/pedrovilarim' README.md && grep -q 'pedrocodeart.netlify.app' README.md`
  - **Pattern:** `README.md`

## 2. Kit README + project pointers

- [x] 2.1 Actualizar título/intro de `sdd-kit/README.md` para ByeByeVibe; preservar comandos `sdd-kit/`
  - **Gate:** `grep -qi 'ByeByeVibe' sdd-kit/README.md && grep -q 'sdd-kit/install.sh' sdd-kit/README.md`
  - **Pattern:** `sdd-kit/README.md`

- [x] 2.2 Actualizar `openspec/project.md` e ponteiros de discovery em `AGENTS.md` / guia § first-contact para o nome público (sem mudar paths)
  - **Gate:** `grep -qi 'ByeByeVibe' openspec/project.md && grep -qi 'ByeByeVibe' AGENTS.md && grep -qi 'ByeByeVibe' doc/sistema-sdd-pedro.md`
  - **Pattern:** `openspec/project.md`

## 3. Avaliação P10 + checklist rename

- [x] 3.1 Marcar P10 como adoptado (ByeByeVibe) em `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`; checklist `[AÇÃO MANUAL]` com rename repo → `byebyevibe`, About, topics
  - **Gate:** `grep -qi 'ByeByeVibe' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -qiE 'P10.*Adopt|Adoptado.*P10|P10.*ByeBye' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'AÇÃO MANUAL' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
  - **Pattern:** `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`

- [x] 3.2 Cosmético opcional: headers/echo topo `sdd-kit/install.sh`, `upgrade.sh`, `verify.sh` → `ByeByeVibe (sdd-kit)` sem alterar paths; se templates sob `sdd-kit/templates/` mudarem, correr `bash sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `grep -qi 'ByeByeVibe' sdd-kit/install.sh && grep -q 'sdd-kit' sdd-kit/install.sh && test ! -d sdd-kit/byebyevibe`
  - **Pattern:** `sdd-kit/install.sh`

## 4. Validação

- [x] 4.1 Validar change e patterns
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate rename-byebyevibe-public-name --strict && bash scripts/verify-task-patterns.sh openspec/changes/rename-byebyevibe-public-name/tasks.md`
  - **Pattern:** `openspec/changes/rename-byebyevibe-public-name/tasks.md`
