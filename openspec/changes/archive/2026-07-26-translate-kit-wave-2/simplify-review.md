# simplify-review

**Change:** translate-kit-wave-2
**Escopo:** 7 ficheiros, +163/-163 linhas
**Veredito:** LEAN

## Achados

_(nenhum acionável sem violar `design.md`)_

## Notas

- Diff é substituição de prosa PT→EN in-place (meta líquida ~0). Sem deps, abstrações, scripts ou paths novos.
- Markers `SDD_KIT_COMMANDS_*`, fences de comando e códigos C1/C2/… preservados — fora de corte (freeze list / G-INV).
- Duplicação AS-IS entre a tabela “What this is” e “Scenarios” no README pré-existia; cortá-la seria reestruturação semântica — **non-goal** do design (“language only”). Fora de scope deste review / → possível follow-up editorial separado.
- Checklist do `proposal.md` marcada no apply é metadado de wave, não complexidade de runtime.

**net: 0 linhas possíveis**

Lean already. Ship.
