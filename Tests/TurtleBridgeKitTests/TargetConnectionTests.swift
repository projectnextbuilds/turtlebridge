import Testing
@testable import TurtleBridgeKit

private struct TargetScan: USBDiscovering {
    var count: Int

    func scan() throws -> [USBDeviceObservation] {
        guard count >= 0 else { throw USBDiscoveryError.matchingServicesFailed(code: -1) }
        let device = USBDeviceObservation(rawProperties: USBRawProperties(productName: "Test controller"))
        return Array(repeating: device, count: count)
    }
}

@Suite("Target USB connection")
struct TargetConnectionTests {
    @Test func connectionLifecycle() {
        #expect(ControllerSnapshot.discoveringTarget.status == .discovering)
        let snapshots = [0, 1, 0, 1, 2, -1].map {
            ControllerSnapshot.targetConnection(using: TargetScan(count: $0))
        }
        #expect(snapshots.map(\.status) == [.notConnected, .connected, .notConnected, .connected, .unavailable, .unavailable])
        #expect(snapshots.map(\.deviceName) == [nil, "Test controller", nil, "Test controller", nil, nil])
    }
}
