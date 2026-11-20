# Contributing to TurtleBridge

## Pre-release contribution pause

TurtleBridge is public but owner-restricted until its first tagged release. External pull requests and repository access requests are not being accepted during this period. Public issues remain available for focused, sanitized feedback; submitting an issue does not create a contributor role or a promise that the proposed work will be adopted.

This policy will be reviewed at the first tagged release. See [GOVERNANCE.md](GOVERNANCE.md) for the decision and access model.

## Before you start

Search existing issues before submitting feedback. Do not begin implementation for TurtleBridge unless the owner has explicitly invited the work after the contribution pause is lifted.

## Development workflow

1. Create a branch from `main`.
2. Make one focused change.
3. Run `swift build` and `swift test`.
4. Record any manual or hardware checks using the pull request template.
5. Open a pull request and state what remains untested.

This workflow currently applies to the repository owner and any explicitly authorized collaborator.

## Hardware observations

A device appearing in System Information does not prove that TurtleBridge can read it, interpret its reports, or make it available to a game. Use the hardware test issue form and include:

- controller manufacturer, model, and connection method;
- Mac model/architecture and macOS version;
- the exact test steps and expected result;
- the observed result, including disconnect/reconnect behavior; and
- sanitized logs or descriptors when they are necessary.

Remove serial numbers, account names, hostnames, local paths, and unrelated devices from diagnostic material.

## Code expectations

- Use Swift concurrency and value types where they simplify ownership.
- Keep platform I/O behind a small boundary and keep parsers deterministic.
- Validate report sizes and indices before reading bytes.
- Prefer fixture-based tests over requiring a controller in automated tests.
- Avoid dependencies until the standard library and Apple frameworks have been considered.

All contributions are licensed under the repository's MIT License.
