# Testing guide

TurtleBridge uses three levels of evidence. Keep them distinct in issues, pull requests, and release notes.

## Automated tests

Run the package checks on any supported development Mac:

```sh
swift build
swift test
```

Future report parsers should use sanitized byte fixtures with happy-path, truncated, oversized, and unknown-value cases. CI must not require physical hardware.

## Manual app checks

For presentation changes, launch `swift run TurtleBridge` and verify the window, labels, resizing, keyboard navigation, VoiceOver descriptions, and light/dark appearances where relevant.

For USB/HID discovery changes:

1. launch the app with no controller attached and select **Scan USB/HID**;
2. attach the documented controller through the recorded cable and adapter path, then scan again;
3. disconnect, reconnect, and scan after each change;
4. confirm the app remains responsive and that displayed metadata contains no serial number, location identifier, hostname, username, or local path; and
5. record the exact commit and observed result in the hardware test issue.

A matching interface is an enumeration result only. It does not show that input reports can be opened or read.

## Hardware tests

Use the hardware test issue form. Record:

- Mac model and Apple/Intel architecture;
- macOS version and build when relevant;
- controller manufacturer, exact model, and connection method;
- app commit or release;
- exact steps, expected result, and observed result; and
- connect, disconnect, reconnect, and sleep/wake coverage when applicable.

Sanitize controller serial numbers, account names, hostnames, local paths, and unrelated device details. USB enumeration alone is an observation, not proof that reports can be read or that a game can use the controller.

## Compatibility language

- **Verified:** repeatable success on the named hardware/software combination with documented steps.
- **Partial:** a specific subset works; list what does and does not.
- **Failed:** the documented test did not succeed; include the failure boundary.
- **Untested:** no evidence has been recorded.

Never broaden a result beyond the exact combination tested.
