import SwiftUI
import TurtleBridgeKit

struct ContentView: View {
    private static let rematchCoreTarget = USBDeviceTarget(
        vendorID: 0x10F5,
        productID: 0x7113
    )

    @State private var snapshot = ControllerSnapshot.placeholder
    @State private var observations: [HIDDeviceObservation] = []
    @State private var usbObservations: [USBDeviceObservation] = []
    @State private var diagnostics = DiagnosticCapture()

    var body: some View {
        TabView {
            diagnosticsView.tabItem { Label("Diagnostics", systemImage: "magnifyingglass") }
            InputViewer(target: Self.rematchCoreTarget)
                .tabItem { Label("Input viewer", systemImage: "gamecontroller") }
        }
    }

    private var diagnosticsView: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("TurtleBridge")
                    .font(.largeTitle.bold())
                Text("Evidence-first controller diagnostics for macOS")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            GroupBox {
                HStack(spacing: 16) {
                    Circle()
                        .fill(.secondary)
                        .frame(width: 12, height: 12)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(snapshot.displayName)
                            .font(.headline)
                        Text(snapshot.status.rawValue)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding(8)
            } label: {
                Text("Controller status")
            }

            VStack(alignment: .leading, spacing: 8) {
                Label("Read-only USB/HID discovery", systemImage: "magnifyingglass")
                    .font(.headline)
                Text(snapshot.detail)
                    .foregroundStyle(.secondary)
                Text("Enumeration does not prove that input reports are readable or that software can use the controller.")
                    .foregroundStyle(.secondary)

                if let usbObservation = usbObservations.first {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(usbObservation.displayName)
                            .font(.headline)
                        Text(usbObservation.diagnosticSummary)
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }
                    .padding(.top, 4)
                }
            }

            if !observations.isEmpty {
                List(Array(observations.enumerated()), id: \.offset) { _, observation in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(observation.displayName)
                            .font(.headline)
                        Text(observation.diagnosticSummary)
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }
                    .padding(.vertical, 4)
                }
                .frame(minHeight: 120)
            }

            Button("Scan USB/HID") {
                scan()
            }
            .keyboardShortcut("r", modifiers: [.command])

            HStack(spacing: 12) {
                Button(diagnostics.isEnabled ? "Stop diagnostics" : "Start diagnostics") {
                    if diagnostics.isEnabled {
                        diagnostics.stop()
                    } else {
                        diagnostics.start()
                    }
                }

                if !diagnostics.entries.isEmpty {
                    Text("\(diagnostics.entries.count) bounded entries")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            if !diagnostics.entries.isEmpty {
                GroupBox {
                    ScrollView {
                        Text(diagnostics.formattedText)
                            .font(.caption.monospaced())
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(minHeight: 80, maxHeight: 120)
                } label: {
                    Text("Sanitized diagnostics")
                }
            }

            Spacer()

            Text("Only allowlisted, non-unique metadata is displayed. Serial numbers and location identifiers are not requested.")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(32)
        .frame(minWidth: 560, minHeight: 560)
    }

    private func scan() {
        diagnostics.recordScanStarted()
        snapshot = ControllerSnapshot(
            status: .discovering,
            detail: "Scanning for game-controller HID interfaces."
        )

        do {
            usbObservations = try SystemUSBDiscovery(
                target: Self.rematchCoreTarget
            ).scan()
            observations = try SystemHIDDiscovery().scan()
            diagnostics.recordScanCompleted(matchingInterfaceCount: observations.count)
            if let usbObservation = usbObservations.first, observations.isEmpty {
                snapshot = ControllerSnapshot(
                    status: .transportObserved,
                    deviceName: usbObservation.displayName,
                    detail: "Target USB transport observed. No matching game-controller HID interface was observed."
                )
            } else if observations.isEmpty {
                snapshot = ControllerSnapshot(
                    status: .notConnected,
                    detail: "Target USB transport and matching game-controller HID interface were not observed."
                )
            } else {
                let name = observations.count == 1
                    ? observations[0].displayName
                    : "\(observations.count) USB/HID interfaces"
                snapshot = ControllerSnapshot(
                    status: .observed,
                    deviceName: name,
                    detail: "Allowlisted interface metadata was observed. Input reports were not read."
                )
            }
        } catch let error as HIDDiscoveryError {
            observations = []
            usbObservations = []
            diagnostics.recordScanFailed()
            snapshot = ControllerSnapshot(
                status: .unavailable,
                detail: "USB/HID discovery could not start (\(error))."
            )
        } catch let error as USBDiscoveryError {
            observations = []
            usbObservations = []
            diagnostics.recordScanFailed()
            snapshot = ControllerSnapshot(
                status: .unavailable,
                detail: "Read-only USB discovery could not start (\(error))."
            )
        } catch {
            observations = []
            usbObservations = []
            diagnostics.recordScanFailed()
            snapshot = ControllerSnapshot(
                status: .unavailable,
                detail: "USB/HID discovery could not start."
            )
        }
    }
}
