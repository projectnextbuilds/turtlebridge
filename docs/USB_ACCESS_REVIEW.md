# USB access review for issue #4

The 2020 M1 MacBook Air running macOS Tahoe 26.6.2 (25G83) sees one Turtle Beach Rematch Core Wired Controller for Xbox (TBC-2001-75) through its included USB-C to USB-A cable and UGREEN USB-A to USB-C adapter. The tested discovery path found zero matching game-controller HID interfaces. The registry supplied vendor `10F5`, product `7113`, and device class/subclass/protocol `FF/47/D0`. These are device-level values. They do not identify an input endpoint. [Hardware record](HARDWARE_OBSERVATIONS.md)

## What can be learned before an exclusive open?

A local probe matched exactly one USB service with those vendor and product IDs. It attempted to obtain the legacy IOKit plug-in interface to ask for the cached configuration header. Plug-in creation returned `0xe00002be` before either getter could run. The probe made zero device-open calls. The selected configuration, interfaces, endpoints, and input layout remain unknown.

## Ownership and distribution

Initializing an IOUSBHost object with default options requests exclusive ownership and can fail if the device is busy. Seize asks its existing owner to close. Capture terminates other clients and drivers and resets the device when the capturing object is destroyed. The VM capture entitlement is specific to virtual machines. A sandboxed USB client has a separate USB entitlement. A successful locally built probe would still leave signing, sandbox behavior and distribution to be tested. A directly distributed Developer ID build also needs an appropriate signing and notarization plan. [Apple initialization reference](https://developer.apple.com/documentation/iousbhost/iousbhostobject/initwithioservice%3Aoptions%3Aqueue%3Aerror%3Ainteresthandler%3A) · [Initialization options](https://developer.apple.com/documentation/iousbhost/iousbhostobjectinitoptions) · [Sandbox USB entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.device.usb) · [VM capture](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.vm.device-access) · [Notarization](https://developer.apple.com/documentation/security/resolving-common-notarization-issues)

## Physical test procedure

1. Obtain the operator's approval for one default-options open of the connected target. Other apps may temporarily lose access. Run as the logged-in user. Verify exactly one matching target and stop if it is absent, ambiguous, busy, or access is denied.
2. Bound the helper's lifetime to five seconds. Ask only for the existing configuration descriptor. Stop if unavailable. Never select a configuration, open an interface or pipe, request an input report, seize, capture, or reset.
3. Record only the fixed header fields available through the SDK. Read variable-length entries only from a buffer with an independently known byte count of at most 4096. Check every entry against both the returned length and the advertised length. Retain only interface class, subclass, protocol and endpoint address, transfer type and packet size. Exclude serials, registry paths, strings and payloads.
4. Release ownership on every path. Repeat the ordinary registry/HID scan and record whether the baseline returned. Stop on a timeout, disconnect, unexpected reply or change in behavior.

## Observed on 2026-11-21

Using the app's discovery code at the source revision in [PR #17](https://github.com/projectnextbuilds/turtlebridge/pull/17), the baseline was one target USB device and zero matching game-controller HID interfaces. The operator approved one default-options open with a five-second deadline. Exactly one service matched the vendor, product and device class tuple. The local helper running under the development tool's permissions received `IOUSBHostErrorDomain` code `0xe00002e2` (`kIOReturnNotPermitted`) at initialization. It exited before obtaining ownership or inspecting a descriptor. The immediate follow-up scan again returned one USB device and zero matching game-controller HID interfaces.

This run leaves the cause of the permission denial unresolved. A regular user-launched build with documented signing and sandbox settings is a separate experiment. No entitlement was added. No device configuration, reset, endpoint access or input read occurred.

Endpoint reads require a separate decision after identifying the interface and an IN endpoint. A future test would need repeated neutral, single-button press and release observations from the operator before any byte can be assigned a control. Until then issue #4 has no verified fixture and issue #5 has no verified input to display.
