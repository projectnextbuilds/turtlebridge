# AGENTS.md

## Purpose

TurtleBridge is an evidence-first macOS controller research project. Keep changes small, testable, and honest about what has been verified on real hardware.

## Working rules

- Read `README.md`, `docs/ARCHITECTURE.md`, and `docs/TESTING.md` before changing behavior.
- Do not claim controller, game, emulator, Steam, or macOS compatibility without a repeatable test record.
- Prefer Apple frameworks and the Swift standard library. Discuss new runtime dependencies in an issue first.
- Keep device discovery, report parsing, and presentation separated so parsing can be tested with sanitized fixtures.
- Never commit controller serial numbers, USB registry dumps containing personal identifiers, signing credentials, or local machine paths.
- Treat input reports and device descriptors as untrusted data. Validate lengths and bounds before parsing.
- Keep diagnostics opt-in and redact machine- or device-specific identifiers by default.
- Add or update tests for behavior changes. Documentation-only changes do not require new tests.
- Treat AI-generated code, tests, research, and claims as untrusted drafts. Follow `docs/AI_DEVELOPMENT.md` and disclose material assistance in the pull request.
- Do not bypass branch protections, required checks, owner review, or the pre-release access policy in `GOVERNANCE.md`.

## Verification

Run these checks before opening a pull request:

```sh
swift build
swift test
```

If a change involves real hardware, add the macOS version, Mac model/architecture, controller model, connection method, expected result, and observed result to the pull request. State clearly what was not tested.

## Change boundaries

- Phase 1 is a scaffold; do not add virtual-controller drivers, privileged helpers, kernel extensions, or background services.
- Avoid broad refactors alongside hardware experiments.
- Update public documentation when a verified capability changes.
- Use focused issues and pull requests with one primary outcome.
