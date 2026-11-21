# Compatibility matrix

The only physical combination tested so far is a Turtle Beach Rematch Core Wired Controller for Xbox (TBC-2001-75) on a 2020 Apple M1 MacBook Air (arm64), macOS Tahoe 26.6.2 (25G83). Every row below refers to this setup with the included USB-C to USB-A cable and a UGREEN USB-A to USB-C adapter connected directly to the Mac.

| Layer or consumer | TurtleBridge revision | Status | Observation |
| --- | --- | --- | --- |
| USB discovery | `cdd9903` | Partial | macOS showed the controller when connected, removed it on unplug, and showed it again on reconnect. [Lifecycle record](HARDWARE_OBSERVATIONS.md#steps-and-observations) |
| Game-controller HID discovery | `cdd9903` | Failed | Expected a matching joystick, gamepad or multi-axis HID interface while connected. The scan returned zero in both connected states. [Lifecycle record](HARDWARE_OBSERVATIONS.md#steps-and-observations) |
| TurtleBridge target-specific USB discovery | `8c01401` | Partial | The app can identify the target's USB transport. Buttons, axes and triggers remain unverified. [Implementation and hardware check](https://github.com/projectnextbuilds/turtlebridge/pull/17) |
| Native game | `8c01401` | Untested | No title tested. |
| Launcher (Steam) | `8c01401` | Untested | No Steam or Steam Input session tested. |
| Emulator | `8c01401` | Untested | No emulator tested. |
| Cloud gaming service | `8c01401` | Untested | No browser or cloud gaming session tested. |

**Verified** requires a repeatable pass for the named consumer and capability. **Partial** means a narrower observation succeeded. **Failed** means a stated expectation was tested and unmet. **Untested** means there is no test run for the combination. There are currently zero verified gameplay combinations.

For a new entry, record the model, connection path, Mac architecture, macOS build, TurtleBridge revision, consumer name and version, expected behavior, observed behavior and reproducible steps. Link the sanitized record before changing a status. [Testing guide](TESTING.md)
