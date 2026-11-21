import CoreHID
import Foundation

private struct GamepadDelegate: HIDVirtualDeviceDelegate {
    func hidVirtualDevice(
        _ device: HIDVirtualDevice, receivedSetReportRequestOfType type: HIDReportType,
        id: HIDReportID?, data: Data
    ) async throws {
        throw HIDDeviceError.unsupported
    }

    func hidVirtualDevice(
        _ device: HIDVirtualDevice, receivedGetReportRequestOfType type: HIDReportType,
        id: HIDReportID?, maxSize: Int
    ) async throws -> Data {
        throw HIDDeviceError.unsupported
    }
}

@main
struct Producer {
    static func main() async throws {
        // Generic Desktop gamepad with eight one-bit buttons in a single input byte.
        let descriptor = Data([
            0x05, 0x01, 0x09, 0x05, 0xA1, 0x01, 0x05, 0x09,
            0x19, 0x01, 0x29, 0x08, 0x15, 0x00, 0x25, 0x01,
            0x75, 0x01, 0x95, 0x08, 0x81, 0x02, 0xC0
        ])
        let properties = HIDVirtualDevice.Properties(
            descriptor: descriptor, vendorID: 0xFFFF, productID: 0x5452,
            product: "TurtleBridge Feasibility Gamepad"
        )
        guard let device = HIDVirtualDevice(properties: properties) else {
            print("virtual_device_created=false")
            return
        }

        print("virtual_device_created=true")
        await device.activate(delegate: GamepadDelegate())
        try await Task.sleep(for: .seconds(1))
        try await device.dispatchInputReport(data: Data([0]), timestamp: .now)
        print("neutral_report_submitted=true")
        try await Task.sleep(for: .seconds(1))
    }
}
