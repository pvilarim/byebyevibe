## Why

`upgrade.sh --apply` (e `install.sh`) copiam ficheiros de `sdd-kit/templates/` para o repo alvo sem verificar a integridade do kit — se `sdd-kit/` for substituído por um kit comprometido (ataque supply chain ou edição local acidental), os ficheiros maliciosos são instalados silenciosamente sem nenhum aviso. Este é o único finding da revisão adversarial 2026-07-25 ainda sem change associado (F-SEC-7, 🟡 significativo).

## What Changes

- Adicionar campo `sha256:` por entrada em `sdd-kit/MANIFEST.yaml` (sha256 do ficheiro de template correspondente).
- `upgrade.sh --apply` verifica o sha256 do ficheiro fonte antes de cada `cp`; aborta com erro se divergir.
- `install.sh` (apply path) faz a mesma verificação, usando a mesma lógica.
- `sdd-kit/verify.sh` adiciona check de paridade entre checksums do MANIFEST e ficheiros actuais em `templates/`.
- Novo script de manutenção `sdd-kit/gen-manifest-checksums.sh` — computa e actualiza os campos `sha256:` no MANIFEST para todos os templates; invocado pelo maintainer antes de commitar nova versão do kit.
- Documentação em `AGENTS.md` sobre como regenerar checksums após editar templates.

## Capabilities

### New Capabilities
- nenhuma

### Modified Capabilities
- `sdd-install-kit`: Adição de requisito de integridade — install e upgrade DEVEM verificar sha256 de cada ficheiro de template antes de aplicar; MANIFEST DEVE conter campo `sha256:` por entrada.

## Impact

- `sdd-kit/MANIFEST.yaml` — novo campo `sha256:` em todas as 26 entradas
- `sdd-kit/upgrade.sh` — bloco apply (~linha 209–253): adicionar verificação sha256 antes de `cp`
- `sdd-kit/install.sh` — função `apply_file()` (~linha 75–100): adicionar verificação sha256 antes de `cp`
- `sdd-kit/verify.sh` — novo `run_check` validando paridade checksums
- Novo ficheiro `sdd-kit/gen-manifest-checksums.sh` (helper de manutenção — não é instalado em repos consumidores)
- `AGENTS.md` (hub) — nota de manutenção sobre atualização de checksums
- Spec delta: `openspec/specs/sdd-install-kit/spec.md` — novo requirement de integridade
