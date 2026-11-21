import SwiftUI
import TurtleBridgeKit

struct ContentView: View {
    @State private var snapshot = ControllerSnapshot.placeholder
    @State private var observations: [HIDDeviceObservation] = []
    @State private var diagnostics = DiagnosticCapture()

    var body: some View {
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
            observations = try SystemHIDDiscovery().scan()
            diagnostics.recordScanCompleted(matchingInterfaceCount: observations.count)
            if observations.isEmpty {
                snapshot = ControllerSnapshot(
                    status: .notConnected,
                    detail: "No matching game-controller HID interface was observed."
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
            diagnostics.recordScanFailed()
            snapshot = ControllerSnapshot(
                status: .unavailable,
                detail: "USB/HID discovery could not start (\(error))."
            )
        } catch {
            observations = []
            diagnostics.recordScanFailed()
            snapshot = ControllerSnapshot(
                status: .unavailable,
                detail: "USB/HID discovery could not start."
            )
        }
    }
}
