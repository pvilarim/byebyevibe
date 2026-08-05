## Why

The root README names the composed stack (OpenSpec, GitNexus, Graphify) but only OpenSpec is a clickable link — GitNexus and Graphify are plain text in both the intro area and the "Stack & companions" section. A visitor cannot reach the upstream projects without leaving the README to search for them, and the intro paragraph gives no pointer to the existing "Core tools" table where each project's role is explained.

## What Changes

- Immediately after the intro paragraph ("An installable toolkit for AI-assisted development…"), add a line naming the composed stack with GitHub links — **OpenSpec**, **GitNexus**, **Graphify** — plus an anchor link to the "Core tools" section so a visitor can jump straight to what each one does.
- In "Stack & companions", add the missing GitHub links for **GitNexus** (`https://github.com/abhigyanpatwari/GitNexus`) and **Graphify** (`https://github.com/Graphify-Labs/graphify`); OpenSpec's existing link is unchanged.
- English README only (`README.md`). No code, logic, or CI behavior touched.

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `sdd-discovery-positioning`: the existing requirement to "name the composed stack (OpenSpec, GitNexus, Graphify)" is tightened to require each name be a hyperlink to its GitHub repository, and to require a pointer from the intro to the Core tools section.

## Impact

- Affected file: `README.md` only (two sections: intro block, "Stack & companions").
- No effect on `sdd-kit/`, CI gates, install scripts, or any consumer repo.
