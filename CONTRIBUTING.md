# Contributing to TurtleBridge

Thank you for helping TurtleBridge turn hardware observations into reproducible software.

## Before you start

Search existing issues and open a focused issue for changes that affect architecture, dependencies, entitlements, hardware access, or compatibility claims. Small documentation corrections can go directly to a pull request.

## Development workflow

1. Create a branch from `main`.
2. Make one focused change.
3. Run `swift build` and `swift test`.
4. Record any manual or hardware checks using the pull request template.
5. Open a pull request and state what remains untested.

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
