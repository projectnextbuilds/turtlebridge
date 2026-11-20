import Testing
@testable import TurtleBridgeKit

@Suite("Controller snapshot")
struct ControllerSnapshotTests {
    @Test("Placeholder makes the unimplemented state explicit")
    func placeholderState() {
        let snapshot = ControllerSnapshot.placeholder

        #expect(snapshot.status == .notConnected)
        #expect(snapshot.deviceName == nil)
        #expect(snapshot.displayName == "No verified controller")
        #expect(snapshot.detail.contains("not implemented"))
    }

    @Test("A non-empty observed device name is displayed")
    func observedDeviceName() {
        let snapshot = ControllerSnapshot(
            status: .discovering,
            deviceName: "Observed USB device",
            detail: "Awaiting interface inspection."
        )

        #expect(snapshot.displayName == "Observed USB device")
    }

    @Test("An empty device name does not imply verified hardware")
    func emptyDeviceName() {
        let snapshot = ControllerSnapshot(
            status: .unavailable,
            deviceName: "",
            detail: "No readable interface was found."
        )

        #expect(snapshot.displayName == "No verified controller")
    }
}
