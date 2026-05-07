---
name: spike-and-stabilize
description: Use when the problem is unclear — unfamiliar API, unknown library behavior, uncertain data shape, performance unknown, or any case where you can't yet describe the feature's shape end-to-end. Enforces throwaway exploratory code in /tmp, captured findings, mandatory deletion of the spike, and a fresh restart under TDD. Never let spike code become production code.
---

# Spike and stabilize

When you don't know enough to describe the feature, you can't write a useful test. Trying anyway produces tests that test your confusion.

A spike is a throwaway experiment that answers one question. Once answered, the spike is **deleted** and the real implementation begins from a blank slate, under TDD.

## When to spike

You should spike when at least one of these is true:

- You don't know how an external API behaves in practice.
- You don't know the shape of the data you'll receive.
- You're not sure a given approach will perform acceptably.
- A library is unfamiliar and the docs are thin.
- The problem domain is new to you and the right abstractions aren't obvious.

If you can describe the end-to-end shape, you don't need a spike. Use `walking-skeleton` instead.

## Process

### 1. Write down the question

Before any code, write the specific question the spike will answer. One sentence. Out loud or in a scratch file.

If you can't write the question, the spike has no end condition and will sprawl.

### 2. Spike in /tmp

All spike code lives in `/tmp/`. Not in the project. Not in a `spike/` folder. Not in a branch. `/tmp/`.

This is non-negotiable. Code in the project tree creates social pressure to "just clean it up and ship". Code in `/tmp/` cannot be shipped because it isn't in the repo.

### 3. Answer the question, nothing more

Write the smallest code that answers the question. No tests, no error handling, no abstractions, no naming things well. Print things. Hardcode things. The spike's job is to produce knowledge, not code.

When the question is answered, stop. Resist the urge to "round it out".

### 4. Capture the findings

Before deleting the spike, write down what you learned:

- Brief findings → mention them in the conversation, then in the eventual commit message of the real implementation.
- Substantial findings (multiple decisions, gotchas, sample data shapes) → a short note in the project's docs or a second-brain entry.

The spike disappears. The knowledge persists.

### 5. Delete the spike — mandatory

Run `rm -rf /tmp/<spike-folder>`. Do not move it into the project. Do not stash it "in case". The spike's value was the knowledge, and you've captured it.

If you find yourself reluctant to delete, the spike code is doing too much work — go capture more findings, then delete. The deletion is not optional.

### 6. Restart under TDD

With the question answered, you can describe the feature's shape. Load `starting-a-feature` (you now have the mental model) and proceed to `walking-skeleton` and `tdd`.

The first real test is written from scratch. You do not look at the spike code while writing it. The spike is gone.

## Anti-patterns

- ❌ Spiking inside the project tree. Always `/tmp/`.
- ❌ Letting the spike "evolve into" the real implementation. Spikes are throwaway; skeletons grow up.
- ❌ Spiking without a written question. Open-ended spikes have no end.
- ❌ Spiking when you already know enough. If you can describe the shape, skip to walking-skeleton.
- ❌ Skipping the deletion step. The spike must die.

## Done

The spike is done when:

- [ ] The original question is answered.
- [ ] Findings are captured somewhere durable.
- [ ] The spike code is deleted from `/tmp/`.
- [ ] You can now describe the feature's shape and move to TDD.
