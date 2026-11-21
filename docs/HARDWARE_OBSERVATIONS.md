# Hardware observations

This page records sanitized, repeatable observations. An observation is evidence about one named environment, not a broad compatibility claim.

## 2026-11-21: Turtle Beach Rematch Core USB and HID lifecycle

### Classification

Partial enumeration: macOS observed the controller at the USB layer, while TurtleBridge observed no matching game-controller HID interface.

### Environment

- Controller: Turtle Beach Rematch Core Wired Controller for Xbox
- Model number: TBC-2001-75
- USB product name: Xbox Rematch Core Wired Controller - Ghost Black Camo/Yellow
- Connection path: included USB-C to USB-A cable, UGREEN USB-A to USB-C adapter, no hub
- Mac: MacBook Air (2020), Apple M1, 8 GB memory, 256 GB SSD
- macOS: Tahoe 26.6.2, build 25G83
- Discovery implementation: `cdd9903a1ffbba03a9eb2d00f745d2477a29e3a7`
- Current main after a copy-only follow-up: `426d358d21941f510f60596287a0a6eb972f7eae`

The full sanitized baseline is recorded in [Test environment](TEST_ENVIRONMENT.md).

### Steps and observations

| State | macOS USB registry | TurtleBridge scan | App behavior |
| --- | --- | --- | --- |
| Connected | Controller product and Turtle Beach manufacturer observed | No matching game-controller HID interface observed | Responsive; no crash |
| Disconnected | Controller absent | No matching game-controller HID interface observed | Responsive; no crash |
| Reconnected | Same controller product and manufacturer observed again | No matching game-controller HID interface observed | Responsive; no crash |

TurtleBridge scanned only Generic Desktop joystick, gamepad, and multi-axis controller usages. It requested allowlisted, non-unique metadata and did not request serial numbers or USB location identifiers.

### Boundary and next question

This result shows that the controller reaches the Mac as a USB device through the documented cable and adapter path. It does not show that macOS exposes it as a matching HID gamepad, that input reports can be read, or that any game or controller-aware software can use it.

The next investigation should inspect sanitized interface classes and usages without collecting unique identifiers or broadening the discovery match based on guesswork.
