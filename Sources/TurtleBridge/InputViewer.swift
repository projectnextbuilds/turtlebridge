import SwiftUI
import TurtleBridgeKit

struct InputViewer: View {
    let target: USBDeviceTarget
    @State private var watching = false
    @State private var connection: ControllerSnapshot?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Input viewer").font(.largeTitle.bold())
            Text("Rematch Core Wired Controller for Xbox").font(.title3)
            if let connection {
                VStack(alignment: .leading, spacing: 6) {
                    Text(connection.status.rawValue).font(.headline)
                    Text(connection.detail)
                }
                .accessibilityElement(children: .combine)
            } else {
                Text("Watch the USB connection to see when the controller connects or disconnects.")
                    .foregroundStyle(.secondary)
            }
            Button(watching ? "Stop watching" : "Watch connection") {
                watching.toggle()
                connection = watching ? .discoveringTarget : nil
            }
            .keyboardShortcut("l", modifiers: .command)
            .accessibilityHint("Updates the controller’s USB connection status while this view is open.")
            Spacer()
        }
        .padding(32)
        .frame(minWidth: 560, minHeight: 420, alignment: .topLeading)
        .task(id: watching) {
            guard watching else { return }
            let discovery = SystemUSBDiscovery(target: target)
            while !Task.isCancelled {
                let latest = await Task.detached(priority: .utility) {
                    ControllerSnapshot.targetConnection(using: discovery)
                }.value
                guard !Task.isCancelled else { return }
                connection = latest
                do { try await Task.sleep(for: .seconds(1)) } catch { return }
            }
        }
        .onDisappear {
            watching = false
            connection = nil
        }
    }
}
