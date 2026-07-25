---
name: document
description: "Write documentation by conforming to the structure already in the repository: README, Diátaxis content (tutorial, how-to, reference, explanation), ADRs, and code comments. Covers reading the existing layout first, the Diátaxis classification lens, and where the craft rules already live. Non-code work, so no TDD and no test list. Use when the deliverable is prose that explains the system."
argument-hint: [what to document]
---

# Document

Write documentation: prose that explains the system. This is non-code work. The `tdd` skill
and the `deliver` ritual do not apply, since there is no production code and no test list. When
a piece of documentation work turns into a code change, route it back through the `triage`
skill.

Craft that already has a home is referenced here, not restated. The writing-style rules in the
global instructions govern tone and phrasing for all prose. The `adr` skill owns architecture
decision records. The code-comment rules in the global instructions govern when a comment earns
its place. This skill adds the structure layer on top: how a repository's documentation is
organized and where a new page belongs.

## Read the existing structure first

Before writing, read the documentation already in the repository: its directory layout, its
section names, and how existing pages are organized. Conform new content to what is there. This
is the same match-the-surrounding-conventions habit that governs code. A repository that
already has a documentation structure keeps it; do not impose a new one.

## Diátaxis

Diátaxis is the lens for classifying a page by its purpose:

- **Tutorial**: learning-oriented. A lesson that takes a beginner through a first success.
- **How-to**: task-oriented. Steps that achieve one specific goal.
- **Reference**: information-oriented. A dry description built for lookup.
- **Explanation**: understanding-oriented. The background and the reasoning.

Keep the modes unmixed within a page. A reference page describes and does not teach; a tutorial
walks a path and does not digress into background. Use Diátaxis to name what a repository's
existing structure already does. Apply it as the default organizing model only when a
repository has no documentation structure yet.

## The artifacts

- **README**: the orientation document. Keep it an entry point: what the project is, how to get
  started, where to go next. Link out to deeper pages instead of duplicating them.
- **Diátaxis content**: tutorials, how-to guides, reference, and explanation, each classified
  and placed per the sections above.
- **ADRs**: the `adr` skill covers the bar for warranting one, the MADR format, and the
  location. This skill governs how the prose reads.
- **Code comments**: the code-comment rules in the global instructions cover when a comment
  earns its place. This skill governs how the prose reads.

## Durable decisions

A design decision surfaced while documenting, if it clears the ADR bar (see the `adr` skill),
graduates into an ADR in `docs/adr/`. That is the one documentation artifact that carries
reasoning a future reader will need.
