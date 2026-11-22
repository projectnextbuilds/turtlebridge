# Testing guide

TurtleBridge uses three levels of evidence. Keep them distinct in issues, pull requests, and release notes.

## Automated tests

Run the package checks on any supported development Mac:

```sh
swift build
swift test
```

Report parsers use sanitized byte fixtures with happy-path, truncated, oversized, and unknown-value cases. The [Rematch input report](REMATCH_INPUT.md) documents the provenance of the first 36-byte fixture and what its masked word can establish. CI must not require physical hardware.

## Manual app checks

For presentation changes, launch `swift run TurtleBridge` and verify the window, labels, resizing, keyboard navigation, VoiceOver descriptions, and light/dark appearances where relevant.

For USB/HID discovery changes:

1. launch the app with no controller attached and select **Scan USB/HID**;
2. attach the documented controller through the recorded cable and adapter path, then scan again;
3. disconnect, reconnect, and scan after each change;
4. confirm the app remains responsive and that displayed metadata contains no serial number, location identifier, hostname, username, or local path; and
5. record the exact commit and observed result in the hardware test issue.

For the documented target-specific USB lookup, confirm that only the target product and allowlisted class metadata appear. The app must not display or request a serial number, location ID, registry path, unrelated USB device, hostname, username, or local path. This lookup must not open, claim, configure, reset, or read from the controller.

A matching interface is an enumeration result only. It does not show that input reports can be opened or read.

## Sanitized diagnostic checks

Diagnostics are off by default. To test an opt-in session:

1. select **Start diagnostics** and confirm a new in-memory capture begins;
2. scan through the intended connect, disconnect, and reconnect sequence;
3. select **Stop diagnostics**;
4. confirm the output contains only the version header, sequence numbers, controlled event names, and bounded interface counts;
5. close and reopen the app to confirm the capture was not written to disk; and
6. follow [Sanitized diagnostics](DIAGNOSTICS.md) before sharing the minimum necessary lines.

Automated tests use fake interface counts to cover appearance, disappearance, count changes, failure, disabled capture, and output bounds. CI does not require physical hardware.

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
