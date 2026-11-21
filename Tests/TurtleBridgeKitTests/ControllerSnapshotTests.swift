import Testing
@testable import TurtleBridgeKit

@Suite("Controller snapshot")
struct ControllerSnapshotTests {
    @Test("Placeholder explains the explicit discovery action")
    func placeholderState() {
        let snapshot = ControllerSnapshot.placeholder

        #expect(snapshot.status == .notConnected)
        #expect(snapshot.deviceName == nil)
        #expect(snapshot.displayName == "No verified controller")
        #expect(snapshot.detail.contains("Scan USB/HID"))
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

    @Test("USB transport status does not imply a HID interface")
    func usbTransportStatus() {
        let snapshot = ControllerSnapshot(
            status: .transportObserved,
            deviceName: "Documented USB target",
            detail: "No matching game-controller HID interface was observed."
        )

        #expect(snapshot.status.rawValue == "USB transport observed")
        #expect(snapshot.displayName == "Documented USB target")
    }
}
