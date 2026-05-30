# Plan: `documentation` craft skill

## Goal

A craft skill `documentation` that governs durable written artifacts (README, decision
records, docstrings / public-API surface) and the "one fact, one home" placement rule, tying
into the existing skill set. It recommends where a fact belongs; the human decides the
placement.

Artifact: `configuration/claude/skills/documentation/SKILL.md`. The symlink loop in
`configure_tools.sh` is generic and picks up the new directory automatically.

## Spine

Write the fewest durable docs that answer a question the code can't; each fact wants one home
chosen by lifespan, and the skill recommends it while the human decides the placement.

## Test list (acceptance checklist — each verifiable by reading)

- [ ] 1. Frontmatter valid & craft-style: `name: documentation` + a `description` naming the
      triggers (README, recording a decision, docstring/public-API, deciding where a fact
      lives). No `disable-model-invocation`.
- [ ] 2. States the spine up front.
- [ ] 3. "Earn it" section: a durable doc is justified only when it carries knowledge
      code/tests/commits can't (why, rejected alternatives, how-to-use); restating the code is
      drift-prone duplication that misleads. YAGNI for prose.
- [ ] 4. "One fact, one home" section: one fact wants one home chosen by lifespan; the skill
      recommends, the human places. No fixed paths or assumed layout; adapt to repo
      conventions; surface the choice when unclear; never relocate docs silently.
- [ ] 5. Names the durable homes concretely, one stance each: README (orient a newcomer, not a
      mirror of the code); decision record (durable why + alternatives rejected and why);
      docstring/public-API (the contract at the boundary, not a restatement of the signature).
- [ ] 6. Defers down explicitly: comments -> global `CLAUDE.md`; commit messages ->
      `readable-code`. Not its territory.
- [ ] 7. Extends `readable-code`: picks up the why too long-lived for a commit and routes it to
      a decision record.
- [ ] 8. The `deliver` handoff: a decision that must outlive the branch is flagged for
      graduation out of `PLAN.md` into a durable decision record before merge; the human
      decides where it lands.
- [ ] 9. Light `observability` tie: one line — runbook/operational docs pair with that skill.
- [ ] 10. "When in doubt" closer in house style: a doc earns its place if a reader would ask
      the question it answers and the code can't; if it only restates the code, delete it.
- [ ] 11. Voice & length consistent with peers: terse, principle-driven, cross-refs in
      backticks, comparable length, no marker comments.

## Decision log

- Scope = the gap the existing config leaves: durable written artifacts + the placement rule.
  Comments and commit messages are already owned elsewhere, so the skill defers them.
- Craft skill, not a ritual: documentation guidance should auto-load on its triggers like
  `readable-code`, not require explicit invocation.
- Thesis = "documentation earns its place or it rots": earn it (carry what the code can't) +
  one fact, one home (by lifespan).
- Name = `documentation`: noun, matches `observability`/`tdd`.
- Placement is human-in-the-loop: there is no one-size-fits-all location, so the skill
  recommends a home by lifespan but the human makes the move. No hardcoded repo layout.
- TDD adaptation: the artifact is prose, so the test list is an acceptance checklist verified
  by reading, and "verification" is a review pass against it plus consistency with the peer
  skills. Likely one commit for the skill (cohesive prose file) rather than 11.

## Open questions

(none)
