import Testing
@testable import TurtleBridgeKit

@Suite("USB device observation")
struct USBDeviceObservationTests {
    @Test("Target matches only the intended vendor and product")
    func targetMatching() {
        let target = USBDeviceTarget(vendorID: 0x10F5, productID: 0x7113)

        #expect(target.matches(USBRawProperties(vendorID: 0x10F5, productID: 0x7113)))
        #expect(!target.matches(USBRawProperties(vendorID: 0x10F5, productID: 0x7114)))
        #expect(!target.matches(USBRawProperties(vendorID: 0x0000, productID: 0x7113)))
    }

    @Test("Sanitized output omits unique identifiers")
    func omitsUniqueIdentifiers() {
        let observation = USBDeviceObservation(
            rawProperties: USBRawProperties(
                productName: "Xbox Rematch Core Wired Controller",
                manufacturer: "Turtle Beach",
                vendorID: 0x10F5,
                productID: 0x7113,
                deviceClass: 0xFF,
                deviceSubclass: 0x47,
                deviceProtocol: 0xD0,
                serialNumber: "PRIVATE-SERIAL",
                locationID: 0x12345678,
                registryPath: "PRIVATE-REGISTRY-PATH"
            )
        )

        #expect(observation.diagnosticSummary.contains("0x10F5"))
        #expect(observation.diagnosticSummary.contains("class=0xFF"))
        #expect(!observation.diagnosticSummary.contains("PRIVATE-SERIAL"))
        #expect(!observation.diagnosticSummary.contains("12345678"))
        #expect(!observation.diagnosticSummary.contains("PRIVATE-REGISTRY-PATH"))
    }

    @Test("Untrusted text is bounded and control characters are removed")
    func sanitizesText() {
        let observation = USBDeviceObservation(
            rawProperties: USBRawProperties(
                productName: "  Controller\n\u{0000}Name  " + String(repeating: "x", count: 200)
            )
        )

        #expect(observation.productName?.contains("\n") == false)
        #expect(observation.productName?.contains("\u{0000}") == false)
        #expect(observation.productName?.hasPrefix("ControllerName") == true)
        #expect(observation.productName?.count == 96)
    }

    @Test("Out-of-range values are rejected")
    func rejectsInvalidValues() {
        let observation = USBDeviceObservation(
            rawProperties: USBRawProperties(
                vendorID: -1,
                productID: 70_000,
                deviceClass: 256,
                deviceSubclass: -1,
                deviceProtocol: 0xD0
            )
        )

        #expect(observation.vendorID == nil)
        #expect(observation.productID == nil)
        #expect(observation.deviceClass == nil)
        #expect(observation.deviceSubclass == nil)
        #expect(observation.deviceProtocol == 0xD0)
    }
}
