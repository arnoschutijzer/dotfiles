---
name: documentation
description: Ground technical documentation in the repository, route it by Diátaxis type, and keep every reference consistent when content changes. Use when writing or revising docs, handovers, READMEs, or presentations.
argument-hint: [what to document]
---

# Documentation

Run this when writing or revising documentation ($ARGUMENTS): reference pages, how-to guides,
handovers, architecture explanations, READMEs, or presentations. It keeps the content grounded
in the repository and the references consistent as the content changes.

Route two things elsewhere. A decision a future reader will need the reasoning for is an ADR
(see the `adr` skill). Code that ships with the documentation goes through the `deliver` ritual.

## Ground-truth before writing

- Read the code, config, and repository state that the document describes before you write a
  claim about it. Confirm current behavior from the source.
- Interview the user for the intent, audience, and scope that the repository cannot answer. Ask
  one question at a time, and give your recommended answer with each.
- Cite the file, command, or output that backs each non-obvious claim, so a reader can
  re-verify it.
- When a claim cannot be traced to the source, mark it as an open question and surface it. Do
  not fill the gap with an invented value or a remembered behavior.

## Route by Diátaxis type

Pick the type before writing. Each serves a different reader and takes a different shape:

- **Tutorial**: a lesson that carries a beginner to a first success. Learning-oriented.
- **How-to guide**: steps that solve one real problem for a reader who knows the basics.
  Task-oriented.
- **Reference**: a description of how the system behaves, structured to mirror the system.
  Information-oriented.
- **Explanation**: the background and reasoning behind a design. Understanding-oriented.

Keep the four separate. When a document needs to do two of these jobs, split it into two.

## Keep references consistent

- When you remove or repurpose content (a slide, a section, a file, a command), remove every
  reference that pointed at it in the same change.
- Sweep for dangling links, orphaned appendix entries, stale cross-references, and
  table-of-contents lines that now point nowhere.
- After the edit, confirm every internal link and cross-reference still resolves.

## Render from one grounded source

- Keep one grounded source document per deliverable. Generate the requested formats (Markdown,
  Marp slides, PDF, translations) from it.
- Treat a format as a render of that source. When the content changes, regenerate every format
  so they stay in step.
