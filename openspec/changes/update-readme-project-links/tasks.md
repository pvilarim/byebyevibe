## 1. Intro block

- [ ] 1.1 Add a line right after the intro paragraph (after "…so you don't invent process from scratch.") naming the composed stack with GitHub links and a pointer to Core tools: `[OpenSpec](https://github.com/Fission-AI/OpenSpec) · [GitNexus](https://github.com/abhigyanpatwari/GitNexus) · [Graphify](https://github.com/Graphify-Labs/graphify) — see [Core tools](#core-tools) for what each one does.`
  - **Pattern:** README.md
  - **Gate:** `grep -q 'github.com/abhigyanpatwari/GitNexus' README.md && grep -q 'github.com/Graphify-Labs/graphify' README.md && grep -q '#core-tools' README.md && echo OK`

## 2. Stack & companions

- [ ] 2.1 In the "Stack & companions" bullet, add GitHub links for GitNexus and Graphify next to the existing OpenSpec link (keep `agents.md` link unchanged).
  - **Pattern:** README.md
  - **Gate:** `grep -A1 'Stack & companions' README.md | grep -q 'github.com/abhigyanpatwari/GitNexus' && grep -A1 'Stack & companions' README.md | grep -q 'github.com/Graphify-Labs/graphify' && echo OK`

## 3. Verify

- [ ] 3.1 Confirm no other README section was altered (docs-only diff, `README.md` is the only changed file).
  - **Gate:** `git diff --name-only | grep -qx README.md && [ "$(git diff --name-only | wc -l)" -eq 1 ] && echo OK`
