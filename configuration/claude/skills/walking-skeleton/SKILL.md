---
name: walking-skeleton
description: Use when starting a feature with a clear end-to-end shape, or when bootstrapping a new project, service, or functional area. Defines how to build the smallest end-to-end slice that compiles, runs, and exercises every layer the feature will eventually touch — anchored by a single failing acceptance test that defines "done". Load alongside or after starting-a-feature when the shape is known.
---

# Walking skeleton

A walking skeleton is the smallest implementation that runs end-to-end, touching every layer the real feature will touch — but doing the trivial thing at each layer.

The point: you discover wiring problems, missing dependencies, and integration assumptions on day one, when they're cheap. Not in week three when you're trying to ship.

## When to use

- Starting a feature whose shape you can describe out loud.
- Bootstrapping a new project, service, or functional area.
- Adding a new path through an existing system (new endpoint, new job, new screen).

If the shape is unclear, use `spike-and-stabilize` instead.

## What it looks like

A walking skeleton has:

1. **A single acceptance test** that exercises the full path. It fails initially. It passing means the slice works.
2. **Every layer present** — input boundary, business logic, output boundary, persistence if relevant. Each does the trivial thing.
3. **Real wiring** — the layers actually call each other. No mocks across layer boundaries.
4. **Trivial behavior** — return a hardcoded value, store nothing useful, ignore most inputs. Real behavior comes later.

## Process

### 1. Write the acceptance test first

The acceptance test is the definition of done for the skeleton. It should:

- Describe the externally observable behavior — what the user, caller, or upstream system sees.
- Use real boundaries where possible. Real HTTP, real database, real file system. Mock only what crosses an organizational boundary you don't control.
- Fail for the right reason — the system doesn't do the thing yet, not "module not found".

Commit the failing test before writing implementation.

### 2. Make it pass with the trivial implementation

For each layer the test exercises, write the smallest code that satisfies the test:

- Endpoint that returns a hardcoded response.
- Function that ignores arguments and returns a constant.
- Repository that reads or writes a single hardcoded record.

If the test passes, the skeleton walks. Commit.

### 3. Replace trivial pieces one at a time, via TDD

Now load the `tdd` skill. Each subsequent increment replaces one piece of trivial behavior with real behavior, driven by a new failing unit test. The acceptance test stays green throughout.

## Anti-patterns

- ❌ Skipping the acceptance test "because we'll add it later". You won't, and the skeleton has no anchor.
- ❌ Building one layer fully before any other layer exists. That's a vertical column, not a skeleton.
- ❌ Mocking layer boundaries inside the skeleton. The whole point is to prove the wiring works.
- ❌ Treating the skeleton as throwaway. The skeleton becomes the feature. Spikes are throwaway; skeletons grow up.

## Done

The skeleton is done when:

- [ ] One acceptance test passes, exercising the full path.
- [ ] Every layer the feature needs exists, even if trivial.
- [ ] The system is in a state you'd be willing to ship (trivial behavior is fine; broken behavior is not).
- [ ] You can hand it to the `tdd` skill and grow it incrementally.
