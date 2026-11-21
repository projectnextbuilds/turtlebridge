import Testing
@testable import TurtleBridgeKit

@Suite("HID device observation")
struct HIDDeviceObservationTests {
    @Test("Sanitized output omits unique identifiers")
    func omitsUniqueIdentifiers() {
        let observation = HIDDeviceObservation(
            rawProperties: HIDRawProperties(
                productName: "Rematch Core Wired Controller",
                manufacturer: "Turtle Beach",
                transport: "USB",
                vendorID: 0x10F5,
                productID: 0x7009,
                primaryUsagePage: 0x01,
                primaryUsage: 0x05,
                serialNumber: "PRIVATE-SERIAL",
                locationID: 0x12345678
            )
        )

        #expect(observation.diagnosticSummary.contains("Turtle Beach"))
        #expect(observation.diagnosticSummary.contains("0x10F5"))
        #expect(!observation.diagnosticSummary.contains("PRIVATE-SERIAL"))
        #expect(!observation.diagnosticSummary.contains("12345678"))
    }

    @Test("Untrusted text is bounded and control characters are removed")
    func sanitizesText() {
        let observation = HIDDeviceObservation(
            rawProperties: HIDRawProperties(
                productName: "  Controller\n\u{0000}Name  " + String(repeating: "x", count: 200)
            )
        )

        #expect(observation.productName?.contains("\n") == false)
        #expect(observation.productName?.contains("\u{0000}") == false)
        #expect(observation.productName?.hasPrefix("ControllerName") == true)
        #expect(observation.productName?.count == 96)
    }

    @Test("Out-of-range numeric properties are rejected")
    func rejectsInvalidIdentifiers() {
        let observation = HIDDeviceObservation(
            rawProperties: HIDRawProperties(
                vendorID: -1,
                productID: 70_000,
                primaryUsagePage: 1,
                primaryUsage: 5
            )
        )

        #expect(observation.vendorID == nil)
        #expect(observation.productID == nil)
        #expect(observation.primaryUsagePage == 1)
        #expect(observation.primaryUsage == 5)
    }

    @Test("Empty metadata has an explicit safe summary")
    func emptyMetadataSummary() {
        let observation = HIDDeviceObservation(rawProperties: HIDRawProperties())

        #expect(observation.displayName == "Observed USB/HID interface")
        #expect(observation.diagnosticSummary == "No allowlisted metadata was reported.")
    }
}
