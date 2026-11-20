# Test environment

This page records the sanitized baseline for the first TurtleBridge hardware investigation. It identifies the planned test target and host. It does not establish compatibility.

## Controller

- Manufacturer: Turtle Beach
- Model number: TBC-2001-75
- Product: Rematch Core Wired Controller for Xbox
- Connection type: Wired USB
- Included cable: USB-C at the controller to USB-A male at the host end
- Adapter: UGREEN USB-A female to USB-C male (exact adapter model not recorded)
- Host connection: Adapter connected directly to a USB-C port on the MacBook Air
- Hub: None
- Serial number: `E20017XXXXXXXXX` (redacted display value)

The real serial number must not be committed, posted, published, or provided to an AI service.

## Mac

- Model: MacBook Air (2020)
- Processor: Apple M1
- Memory: 8 GB
- Storage: 256 GB SSD
- macOS version: Tahoe 26.6.2
- macOS build number: 25G83

## TurtleBridge baseline

- Baseline commit: `06b6a371f4bb8e33be2ea9832e353d5d5e9ce8d0`
- Baseline scope: Phase 1 application scaffold and governance only
- Device access: Not implemented in the baseline
- Hardware observations: None recorded yet

## Privacy procedure

Before publishing a test record:

1. Replace the controller serial number with the redacted display value above.
2. Remove usernames, account names, hostnames, local paths, and unrelated devices.
3. Review all public artifacts for identifiers in titles, menus, logs, and unrelated content.
4. Share only the minimum descriptor or log excerpt needed to reproduce an observation.

## Observation requirements

For every hardware observation, record:

- the TurtleBridge commit used;
- whether the connection path changed from the baseline above; and
- only the minimum sanitized descriptor or log excerpt needed to reproduce the observation.

Enumeration or a successful connection is not proof that reports can be read, inputs can be interpreted, or games can use the controller.
