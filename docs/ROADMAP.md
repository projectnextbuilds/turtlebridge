# Roadmap

The roadmap is ordered by technical uncertainty. Passing one milestone permits investigation of the next; it does not automatically establish compatibility.

## Milestone 1: Foundation and USB diagnostics

- Establish the Swift package, public documentation, tests, and CI.
- Record the exact controller and macOS test environment without publishing unique identifiers.
- Enumerate USB/HID interfaces and document permissions or entitlements required.
- Capture sanitized, bounded diagnostic observations across connect, disconnect, and reconnect.

**Exit evidence:** a contributor can repeat the documented steps and obtain the same class of sanitized observations from the test controller.

## Milestone 2: Controller input tester

- Build fixture-backed parsing for observed reports.
- Display verified buttons, axes, triggers, and connection state.
- Handle malformed reports and device removal without crashing.

**Exit evidence:** automated fixtures cover known report boundaries, and live tests show repeatable input state for the exact tested hardware/software matrix.

## Milestone 3: Virtual controller feasibility

- Research current public macOS mechanisms and their security/distribution constraints.
- Prototype only the smallest path needed to test whether controller-aware software receives output.
- Record failure modes and installation requirements.

**Exit evidence:** a documented prototype result supports or rejects a specific architecture on a named macOS version.

## Milestone 4: Compatibility and release

- Add mappings and lifecycle hardening only for verified devices.
- Test named games, launchers, emulators, or cloud services individually.
- Publish a compatibility matrix that separates verified, partial, failed, and untested combinations.
- Prepare signed release artifacts only after the distribution model is reviewed.

**Exit evidence:** release notes link to repeatable tests and clearly state the supported matrix and known limitations.
