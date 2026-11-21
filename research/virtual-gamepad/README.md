# Virtual gamepad feasibility

**Decision on 2026-11-21.** The standalone CoreHID producer could not create the synthetic gamepad in the tested local configuration. The independent TurtleBridge feasibility observer opened successfully and listened for six seconds. Across two runs it saw zero matching devices and zero neutral input reports. The producer's failable initializer provided no error reason. Keep this route out of the shipping app until a signed configuration can pass the consumer test.

## Options considered

| Public API | Access and distribution | Fit for this experiment |
| --- | --- | --- |
| CoreHID HIDVirtualDevice | Native macOS user-space API. Apple documents a virtual HID device entitlement. The test used an ad hoc signed executable, with no added entitlement, administrator prompt, installation or driver. Distribution with a provisioned identity and entitlement remains untested. | Can describe a synthetic gamepad and submit a report to a separate observer. [CoreHID guide](https://developer.apple.com/documentation/corehid/creatingvirtualdevices) · [Entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.hid.virtual.device) |
| Game Controller GCVirtualController | The game presents on-screen controls using its own supported iOS, iPadOS or Mac Catalyst app. It ships as part of the consuming app with no separately installed driver. | The API is scoped to that game. It does not establish cross-process output to an independent native Mac consumer. [Apple reference](https://developer.apple.com/documentation/gamecontroller/gcvirtualcontroller) |
| DriverKit and HIDDriverKit | A driver system extension needs a separately signed and provisioned extension, applicable Apple-approved entitlements, a containing app and system-extension activation. | A larger installation and permission commitment. No extension or installer was built or activated. [Entitlement requests](https://developer.apple.com/documentation/driverkit/requesting-entitlements-for-driverkit-development) · [System extensions](https://developer.apple.com/documentation/systemextensions) |

## Reproduce the experiment

The pass criterion was published before implementing the probe. It requires a second process to match the synthetic gamepad and receive its one-byte neutral input report. [Experiment definition](https://github.com/projectnextbuilds/turtlebridge/issues/6#issuecomment-7066419577)

Build these two files in a scratch directory using a macOS SDK that includes CoreHID. From this directory on Apple silicon:

```sh
scratch=$(mktemp -d)
sdk=$(xcrun --sdk macosx --show-sdk-path)
swiftc -sdk "$sdk" -target arm64-apple-macos15 -parse-as-library Producer.swift -o "$scratch/producer"
swiftc -sdk "$sdk" -target arm64-apple-macos15 Consumer.swift -o "$scratch/observer"
```

Start `"$scratch/observer"` in one terminal. When it prints `consumer_ready=true`, run the producer from a second terminal using the full scratch path. A pass requires `virtual_device_created=true` and `neutral_report_submitted=true` from the producer, plus `consumer_match=true` and `consumer_neutral_report=true` from the observer. End the run at `consumer_finished=true`. The observer filters on the synthetic name, IDs and gamepad usage. The producer submits at most one neutral report.

## Test record

The test used a 2020 M1 MacBook Air (arm64), macOS Tahoe 26.6.2 (25G83), Swift 6.3.3 and the macOS 26.5 SDK. Both binaries ran as the logged-in user within the development tool's restricted process environment. Each run produced the following output:

| Producer | Observer |
| --- | --- |
| `virtual_device_created=false` | `consumer_ready=true`, then `consumer_finished=true` |

The producer stopped before activation or submission. The observer is a HID test consumer. Games, launchers, emulators and cloud services remain untested. The physical controller supplied no data to either process. The app's entitlements and installed software were unchanged. A future run with different permissions must record its signing identity type, entitlements, installation or approval steps, and the independent consumer result.
