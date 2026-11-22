# USB access review for issue #4

The 2020 M1 MacBook Air running macOS Tahoe 26.6.2 (25G83) sees one Turtle Beach Rematch Core Wired Controller for Xbox (TBC-2001-75) through its included USB-C to USB-A cable and UGREEN USB-A to USB-C adapter. The tested discovery path found zero matching game-controller HID interfaces. The registry supplied vendor `10F5`, product `7113`, and device class/subclass/protocol `FF/47/D0`. These are device-level values. They do not identify an input endpoint. [Hardware record](HARDWARE_OBSERVATIONS.md)

## What can be learned before an exclusive open?

A local probe matched exactly one USB service with those vendor and product IDs. It attempted to obtain the legacy IOKit plug-in interface to ask for the cached configuration header. Plug-in creation returned `0xe00002be` before either getter could run. That probe made zero device-open calls.

## Ownership and distribution

Initializing an IOUSBHost object with default options requests exclusive ownership and can fail if the device is busy. Seize asks its existing owner to close. Capture terminates other clients and drivers and resets the device when the capturing object is destroyed. The VM capture entitlement is specific to virtual machines. A sandboxed USB client has a separate USB entitlement. A successful locally built probe would still leave signing, sandbox behavior and distribution to be tested. A directly distributed Developer ID build also needs an appropriate signing and notarization plan. [Apple initialization reference](https://developer.apple.com/documentation/iousbhost/iousbhostobject/initwithioservice%3Aoptions%3Aqueue%3Aerror%3Ainteresthandler%3A) · [Initialization options](https://developer.apple.com/documentation/iousbhost/iousbhostobjectinitoptions) · [Sandbox USB entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.device.usb) · [VM capture](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.vm.device-access) · [Notarization](https://developer.apple.com/documentation/security/resolving-common-notarization-issues)

## Initial descriptor test procedure

1. Obtain the operator's approval for one default-options open of the connected target. Other apps may temporarily lose access. Run as the logged-in user. Verify exactly one matching target and stop if it is absent, ambiguous, busy, or access is denied.
2. Bound the helper's lifetime to five seconds. Ask only for the existing configuration descriptor. Stop if unavailable. Never select a configuration, open an interface or pipe, request an input report, seize, capture, or reset.
3. Record only the fixed header fields available through the SDK. Read variable-length entries only from a buffer with an independently known byte count of at most 4096. Check every entry against both the returned length and the advertised length. Retain only interface class, subclass, protocol and endpoint address, transfer type and packet size. Exclude serials, registry paths, strings and payloads.
4. Release ownership on every path. Repeat the ordinary registry/HID scan and record whether the baseline returned. Stop on a timeout, disconnect, unexpected reply or change in behavior.

## Observed on 2026-11-21

Using the app's discovery code at the source revision in [PR #17](https://github.com/projectnextbuilds/turtlebridge/pull/17), the baseline was one target USB device and zero matching game-controller HID interfaces. The operator approved one default-options open with a five-second deadline. Exactly one service matched the vendor, product and device class tuple. The local helper running under the development tool's permissions received `IOUSBHostErrorDomain` code `0xe00002e2` (`kIOReturnNotPermitted`) at initialization. It exited before obtaining ownership or inspecting a descriptor. The immediate follow-up scan again returned one USB device and zero matching game-controller HID interfaces.

This run leaves the cause of the permission denial unresolved. A regular user-launched build with documented signing and sandbox settings is a separate experiment. No entitlement was added. No device configuration, reset, endpoint access or input read occurred.

## Follow-up on the connected Rematch

The following local app tests used the same M1 MacBook Air, controller and cable path. Each build used ad hoc signing and the hardened runtime, without added entitlements.

| Test | Observed result |
| --- | --- |
| Inspect configuration descriptor at index 0 | Configuration value 1 advertises interface 0, alternate 0 with interrupt IN endpoint `0x81` and a 64-byte maximum packet. [Descriptor record](https://github.com/projectnextbuilds/turtlebridge/issues/4#issuecomment-7068884597) |
| Read the active configuration | The controller returned one byte, `0x00`. [Configuration query](https://github.com/projectnextbuilds/turtlebridge/issues/4#issuecomment-7069825405) |
| Select configuration 1 and read back | The controller returned `0x01`. After release, walking the matched device’s USB children found interfaces 0 and 1. The initial filter missed interface 0. Its publication time is unknown. [Selection and registry comparison](https://github.com/projectnextbuilds/turtlebridge/issues/4#issuecomment-7070840904) |
| Read once from interface 0 | The app opened the interface and submitted a read on `0x81`. The two-second wait expired before completion. The app released ownership. The final scan found one matching USB device, one interface 0 and zero target HID services. [Packet test](https://github.com/projectnextbuilds/turtlebridge/issues/4#issuecomment-7072028015) |
| Sample input for up to 16 seconds | Build `461e8a5506ac` classified 33 transfers as 32-byte primary GIP Hello messages. It recorded zero gamepad input frames and zero other transfers in that run. The controller and interface counts agreed before and after. Two other runs recorded zero transfers. [Button-test record](https://github.com/projectnextbuilds/turtlebridge/issues/4#issuecomment-7072293011) |

Build `7e0fff7d9e3a` received a fresh Hello, sent one five-byte gamepad Start command on `0x02`, and observed one 36-byte gamepad input frame on `0x81` at 0.02 seconds. Its masked digital-button word was `0000`. One further transfer was unclassified. No press or release transition was recorded. Ownership was released and the baseline counts agreed. The next comparison begins with A held before capture. [Start and input record](https://github.com/projectnextbuilds/turtlebridge/issues/4#issuecomment-7072550124)
