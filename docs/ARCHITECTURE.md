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

The first discovery boundary uses Apple's IOKit HID APIs behind `HIDDiscovering`. It performs an explicit, read-only scan for Generic Desktop joystick, gamepad, and multi-axis controller usages. The system adapter requests only product, manufacturer, transport, vendor/product IDs, and primary usage metadata. It does not request serial numbers or location identifiers and does not read input reports.

`HIDDeviceObservation` validates numeric ranges, removes control characters, bounds descriptor text, and exposes only the allowlisted fields. SwiftUI calls the boundary but does not own IOKit logic. Verified behavior is limited to the exact records in [Hardware observations](HARDWARE_OBSERVATIONS.md).

`SystemUSBDiscovery` is a separate, target-specific registry lookup for the documented controller. It reads vendor/product IDs to select the exact target, then reads product, manufacturer, and device class/subclass/protocol only for that match. It does not retain or expose unrelated device metadata, create an `IOUSBHostObject`, establish exclusive ownership, request serial or location properties, change configuration, reset hardware, access endpoints, or read reports.

Initializing an `IOUSBHost` object requests exclusive ownership. Seize asks an existing owner to close. Capture terminates other clients and drivers. The [USB access review](USB_ACCESS_REVIEW.md) records the ownership implications, the cached-descriptor attempt, and the result of one default-options open on the research target.

`DiagnosticCapture` is a separate, in-memory state model. It is off by default, accepts only controlled event kinds and bounded interface counts, and retains at most 64 entries. It accepts no free-form strings, device identifiers, timestamps, raw reports, or system metadata. SwiftUI controls the explicit start and stop actions and renders selectable text, but it does not define the diagnostic format.

## Decisions deferred until evidence exists

- Whether the initial controller exposes a usable HID interface on current macOS.
- Whether an exclusive USB session can be justified and tested without unsafe device-state changes.
- Whether input reports can be read reliably across disconnects and sleep/wake cycles.
- Whether a virtual controller can be implemented safely with current public macOS APIs and acceptable installation requirements.
- Which games, launchers, emulators, or cloud services can consume any eventual output.

Kernel extensions, privileged helpers, background services, and distribution/signing choices are outside Phase 1. A later decision must document the verified need, security impact, maintenance cost, and current platform requirements before adding any of them.
