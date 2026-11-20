# Architecture

TurtleBridge is being built in stages so observations about one controller do not become untested system-wide assumptions.

## Intended boundaries

```text
USB/HID discovery -> sanitized observations -> report parsing -> app presentation
                                              -> fixture-based tests
```

- **Discovery** will enumerate relevant USB/HID interfaces and expose the minimum metadata needed for diagnostics.
- **Observations** will describe connection state and raw report boundaries without retaining personal or device-specific identifiers.
- **Parsing** will convert known, validated report layouts into controller state. It must reject truncated or unexpected input safely.
- **Presentation** will display diagnostics and inputs without owning USB/HID logic.

The Phase 1 package contains only the presentation scaffold and a small state model. It performs no device access.

## Decisions deferred until evidence exists

- Whether the initial controller exposes a usable HID interface on current macOS.
- Whether input reports can be read reliably across disconnects and sleep/wake cycles.
- Whether a virtual controller can be implemented safely with current public macOS APIs and acceptable installation requirements.
- Which games, launchers, emulators, or cloud services can consume any eventual output.

Kernel extensions, privileged helpers, background services, and distribution/signing choices are outside Phase 1. A later decision must document the verified need, security impact, maintenance cost, and current platform requirements before adding any of them.
