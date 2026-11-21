# TurtleBridge

[![CI](https://github.com/projectnextbuilds/turtlebridge/actions/workflows/ci.yml/badge.svg)](https://github.com/projectnextbuilds/turtlebridge/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

TurtleBridge is an early-stage, open-source macOS project exploring how wired USB game controllers can be inspected, tested, and, where technically possible, made useful in games and other controller-aware software.

> [!IMPORTANT]
> TurtleBridge does **not** currently provide controller compatibility or system-wide gamepad support. Hardware support will be listed only after repeatable tests on real devices and macOS versions.

## Current status

Phase 1 established a small, verifiable foundation:

- a native SwiftUI application scaffold;
- a testable model for displaying diagnostic state;
- contributor, security, and testing guidance;
- GitHub issue templates and continuous integration; and
- a roadmap that puts USB/HID discovery ahead of input mapping or compatibility claims.

TurtleBridge includes an explicit, read-only USB/HID scan for game-controller interfaces. The scan displays only allowlisted, non-unique metadata. It does not request serial numbers or location identifiers, read input reports, or establish compatibility.

For the documented research target, the same action also performs a target-specific USB registry lookup. It reports only allowlisted product and USB class metadata and does not open, claim, configure, reset, or read from the device.

Optional [sanitized diagnostics](docs/DIAGNOSTICS.md) record only controlled scan events and bounded interface counts. Capture is off by default, remains in memory, and has no telemetry or upload path.

The first physical research target is the wired Turtle Beach Rematch Core controller. That is a test target, not a compatibility statement.

The sanitized [test environment](docs/TEST_ENVIRONMENT.md) records the planned hardware baseline. It does not record a compatibility result.

The first [hardware observation](docs/HARDWARE_OBSERVATIONS.md) records that macOS sees the controller at the USB layer while the current game-controller HID scan finds no matching interface. This is partial enumeration evidence, not controller compatibility.

## Build locally

You need a Mac with a Swift 6 toolchain (normally installed with Xcode).

```sh
git clone https://github.com/projectnextbuilds/turtlebridge.git
cd turtlebridge
swift build
swift test
swift run TurtleBridge
```

The app starts with a “Not connected” placeholder. The **Scan USB/HID** action uses Apple's IOKit HID APIs to enumerate matching interfaces without reading reports or modifying a device. See [Hardware observations](docs/HARDWARE_OBSERVATIONS.md) for the exact tested result and its limits.

## Project direction

Development follows evidence-first milestones:

1. **Foundation and USB diagnostics:** identify interfaces and collect safe, reproducible observations.
2. **Controller input tester:** display verified buttons, sticks, triggers, and connection state.
3. **Virtual controller feasibility:** test current macOS options before selecting an architecture.
4. **Compatibility and release:** publish only device/software combinations that have passed documented tests.

See the [roadmap](docs/ROADMAP.md), [architecture notes](docs/ARCHITECTURE.md), and [testing guide](docs/TESTING.md) for the boundaries behind those stages.

## Governance and AI use

TurtleBridge is public but intentionally restricted during pre-release. The project publishes its roadmap, decisions, limitations, and verification practices while write access and pull request creation remain limited to the owner. External contributions are paused until the first tagged release; public issues remain available for structured feedback.

See [GOVERNANCE.md](GOVERNANCE.md) for decision and access controls, and [AI-assisted development](docs/AI_DEVELOPMENT.md) for how AI output is reviewed, tested, disclosed, and kept from becoming evidence by assertion.

## Contributing

External contributions are paused until the first tagged release. You may still use the issue forms for focused, sanitized feedback. Read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting information.

Please do not report a device as supported based only on USB enumeration or a single successful session. Remove serial numbers and other machine-specific identifiers from logs before sharing them.

## Security

Do not publish sensitive device or system information in an issue. See [SECURITY.md](SECURITY.md) for private reporting guidance.

## License

TurtleBridge is available under the [MIT License](LICENSE).
