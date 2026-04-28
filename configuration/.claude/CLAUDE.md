<!--# BEGIN SNYK GLOBAL RULE -->
---
alwaysApply: true
always_on: true
trigger: always_on
applyTo: "**"
description: Snyk Security At Inception
---

# Project security best practices

- Always run snyk_code_scan tool for new first party code that is generated in a Snyk-supported language.
- If any security issues are found based on newly introduced or modified code or dependencies, attempt to fix the issues using the results context from Snyk.
- Rescan the code after fixing the issues to ensure that the issues were fixed and that there are no newly introduced issues.
- Repeat this process until no new issues are found.
<!--# END SNYK GLOBAL RULE -->

## Scratch files and experiments

When running quick experiments, throwaway scripts, or test files:
- Use the `/tmp/` root directory.
- Delete them once the experiment is done and findings are captured
- Don't leave `test_foo.py`, `debug.js`, `experiment.sh`, etc. lying around in the project root
