import SwiftUI
import TurtleBridgeKit

struct ContentView: View {
    private let snapshot = ControllerSnapshot.placeholder

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
                Label("Phase 1 scaffold", systemImage: "hammer")
                    .font(.headline)
                Text(snapshot.detail)
                    .foregroundStyle(.secondary)
                Text("A controller will be named as supported only after repeatable hardware tests.")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("No device access is performed by this build.")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(32)
        .frame(minWidth: 560, minHeight: 360)
    }
}
