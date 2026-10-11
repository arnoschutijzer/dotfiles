# Test-pruning campaign

Use only for an explicitly requested subsystem-wide audit. The authoring gate,
retention bar, and candidate evidence in [SKILL.md](SKILL.md) still apply.

1. Record the requested boundary and a baseline revision. Run the existing
   owner suites; retain failures separately until their cause is understood.
2. Inventory tests by the production behavior they protect. Classify each as
   retain, repair, consolidate, or delete with the candidate evidence required
   by the main skill. Read relevant history before removing unusual coverage.
3. Name the remaining primary test owner for every retained contract. Move
   useful assertions before deleting duplicate suites or test-only seams.
4. Apply coherent batches, serializing edits to shared fixtures and harnesses.
   Follow the repository's test, formatter, and generated-file conventions.
5. Have an independent reviewer check that removed coverage still has adequate
   proof. For a repaired regression, verify the test catches the original bug;
   restore any control changes before continuing.
6. Treat an existing failure as a possible product defect. Do not delete the
   test to make the suite pass. Repair within scope or report the defect.
7. Reconcile with current base-branch changes using the repository's Git
   workflow. Preserve newly introduced behavioral coverage when consolidating.
8. Report the removed categories, retained contracts, tests actually run,
   unresolved defects, and commit/PR state. Do not optimize for deletion count.
