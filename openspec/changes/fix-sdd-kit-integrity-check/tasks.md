## 1. Helper: gen-manifest-checksums.sh

- [ ] 1.1 Criar `sdd-kit/gen-manifest-checksums.sh` — lê cada entrada `source:` do MANIFEST e actualiza (ou insere) o campo `sha256:` inline usando Python + `sha256sum`/`shasum -a 256`; exit 0 se todos os templates existem, exit 1 se algum está ausente
  - **Gate:** `test -x sdd-kit/gen-manifest-checksums.sh`

- [ ] 1.2 Correr `bash sdd-kit/gen-manifest-checksums.sh` para popular todos os campos `sha256:` no MANIFEST.yaml; verificar que todas as 26 entradas têm sha256 preenchido
  - **Gate:** `python3 -c "import sys,re; t=open('sdd-kit/MANIFEST.yaml').read(); missing=[l for l in t.splitlines() if l.strip().startswith('- path:') and 'sha256' not in t[t.index(l):t.index(l)+300]]; sys.exit(1 if missing else 0)" && echo OK`

## 2. install.sh — verificação de integridade no apply path

- [ ] 2.1 Adicionar função `_sha256()` no topo de `sdd-kit/install.sh` — detecta `sha256sum` ou `shasum -a 256`; se nenhum disponível emite WARN e retorna string vazia
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -n sdd-kit/install.sh && grep -q '_sha256()' sdd-kit/install.sh`

- [ ] 2.2 Actualizar o bloco Python em `install.sh` para emitir `sha256` como 4.º campo do TSV (campo vazio se ausente no MANIFEST)
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -q "sha256" sdd-kit/install.sh`

- [ ] 2.3 Actualizar `apply_file()` em `install.sh` para aceitar parâmetro `sha256`; antes do `cp` em COPY path: se sha256 não vazio verificar hash; WARN se ausente, ERROR+exit se mismatch
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -n sdd-kit/install.sh && grep -qE 'integrity check failed|no sha256' sdd-kit/install.sh`

- [ ] 2.4 Actualizar o loop principal de `install.sh` (linha ~140) para ler o 4.º campo sha256 do TSV e passá-lo para `apply_file()`
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -n sdd-kit/install.sh`

## 3. upgrade.sh — verificação de integridade no --apply

- [ ] 3.1 Adicionar função `_sha256()` no topo de `sdd-kit/upgrade.sh` — mesma lógica de `install.sh` (D6)
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `bash -n sdd-kit/upgrade.sh && grep -q '_sha256()' sdd-kit/upgrade.sh`

- [ ] 3.2 Actualizar o bloco Python no `--apply` path de `upgrade.sh` para emitir `sha256` como 4.º campo do TSV
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -c "sha256" sdd-kit/upgrade.sh | grep -qv '^0'`

- [ ] 3.3 Adicionar verificação sha256 no loop `--apply` de `upgrade.sh` antes do `cp`: se sha256 não vazio verificar hash; WARN se ausente, ERROR+exit se mismatch
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `bash -n sdd-kit/upgrade.sh && grep -qE 'integrity check failed|no sha256' sdd-kit/upgrade.sh`

## 4. verify.sh — parity check no hub

- [ ] 4.1 Adicionar bloco de parity check em `sdd-kit/verify.sh`: condicional `if [[ -d "$REPO_ROOT/sdd-kit/templates" ]]`; para cada entry do MANIFEST com `sha256:`, comparar digest do template file; WARN se campo ausente, FAIL se mismatch
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `bash -n sdd-kit/verify.sh && grep -q 'kit-integrity' sdd-kit/verify.sh`

## 5. MANIFEST.yaml — campo sha256 em todas as entradas

- [ ] 5.1 Confirmar que todos os campos `sha256:` foram populados pelo script (task 1.2) — nenhuma entrada sem sha256 no MANIFEST
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `python3 -c "import re; t=open('sdd-kit/MANIFEST.yaml').read(); blocks=re.split(r'  - path:', t)[1:]; bad=[b.split(chr(10))[0].strip() for b in blocks if 'sha256:' not in b]; print('Missing sha256:', bad) if bad else print('OK'); import sys; sys.exit(1 if bad else 0)"`

## 6. Documentação e spec archive

- [ ] 6.1 Adicionar nota de manutenção em `AGENTS.md` (hub): "Ao editar qualquer ficheiro em `sdd-kit/templates/`, correr `bash sdd-kit/gen-manifest-checksums.sh` antes de commitar"
  - **Pattern:** `AGENTS.md`
  - **Gate:** `grep -q 'gen-manifest-checksums' AGENTS.md`

- [ ] 6.2 Confirmar que a delta spec `openspec/specs/sdd-install-kit/` ainda não existe (change arquiva delta em `openspec/changes/fix-sdd-kit-integrity-check/specs/` para merge em archive)
  - **Gate:** `test ! -f openspec/specs/sdd-install-kit/spec.md || grep -q 'sha256' openspec/specs/sdd-install-kit/spec.md`

- [ ] 6.3 Validar change com openspec antes de commit
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate fix-sdd-kit-integrity-check 2>&1 | grep -qiE 'valid|pass|ok'`
