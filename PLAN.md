# Plan: testing strategies skill

## Goal

Add testing-strategy guidance as one umbrella `testing` skill that routes to four
detail files: acceptance testing, contract testing, test data, property-based
testing. The umbrella `SKILL.md` is the strategy map (the pyramid, where each
strategy sits against the hexagonal boundary, how they compose) and is the only
file that registers as a skill.

## Structure

```
configuration/.claude/skills/testing/
├── SKILL.md          # registered skill: the strategy map (model-invocable)
├── acceptance.md     # detail file (no frontmatter)
├── contract.md
├── test-data.md
└── property-based.md
```

## Test list

1. [x] `testing/SKILL.md` — strategy map; anchors to `tdd` and
   `hexagonal-architecture`; routes to the four detail files.
2. [x] `testing/acceptance.md` — outside-in through the inbound port, real
   adapters, the double loop.
3. [x] `testing/contract.md` — consumer-driven contracts at the outbound ports.
4. [x] `testing/test-data.md` — builders/factories, deterministic fixtures,
   anonymized data.
5. [x] `testing/property-based.md` — generated inputs, invariants, shrinking.
6. [x] Back-references — one-line pointer from `tdd/SKILL.md` and
   `hexagonal-architecture/SKILL.md` to the `testing` skill.

## Verification gate

No automated test suite for prose. Per item: self-review against the
writing-style rules in `configuration/.claude/CLAUDE.md` (no em-dashes,
matter-of-fact tone, no contrastive negations, no antithetical parallelisms,
plain headings) and consistency with the existing skills (frontmatter shape,
concise length, cross-reference idiom). Final item: a consistency pass across the
set and confirmation that the configure symlink loop picks up the new directory.

## Decision log

- Umbrella over four flat siblings. The four strategies are orthogonal and
  composable, not a mutually-exclusive route, so the umbrella acts as a map, not
  a router. There is a real shared overview (the test pyramid against the
  hexagonal boundary) worth stating once. The user is optimizing for quality and
  results, not for less context, so the extra detail and the single composition
  home win over the precise per-trigger loading of four siblings.
- Only `SKILL.md` registers as a skill (one list entry, model-invocable). The
  four detail files are resources it routes to, so they carry no skill
  frontmatter.
- Detail files drop the redundant `-testing` suffix since they live in
  `testing/`.
- This is the repo's first multi-file skill. The configure script symlinks the
  whole skill directory, so the detail files come along with no wiring change.

## Open questions

None.
