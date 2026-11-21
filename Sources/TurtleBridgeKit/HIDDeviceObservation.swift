import Foundation

public struct HIDDeviceObservation: Equatable, Sendable {
    public let productName: String?
    public let manufacturer: String?
    public let transport: String?
    public let vendorID: UInt16?
    public let productID: UInt16?
    public let primaryUsagePage: UInt16?
    public let primaryUsage: UInt16?

    init(rawProperties: HIDRawProperties) {
        productName = HIDMetadataSanitizer.text(rawProperties.productName)
        manufacturer = HIDMetadataSanitizer.text(rawProperties.manufacturer)
        transport = HIDMetadataSanitizer.text(rawProperties.transport)
        vendorID = HIDMetadataSanitizer.identifier(rawProperties.vendorID)
        productID = HIDMetadataSanitizer.identifier(rawProperties.productID)
        primaryUsagePage = HIDMetadataSanitizer.identifier(rawProperties.primaryUsagePage)
        primaryUsage = HIDMetadataSanitizer.identifier(rawProperties.primaryUsage)
    }

    public var displayName: String {
        productName ?? "Observed USB/HID interface"
    }

    public var diagnosticSummary: String {
        var fields: [String] = []

        if let manufacturer {
            fields.append("manufacturer=\(manufacturer)")
        }
        if let vendorID {
            fields.append("vendor=\(Self.hex(vendorID))")
        }
        if let productID {
            fields.append("product=\(Self.hex(productID))")
        }
        if let transport {
            fields.append("transport=\(transport)")
        }
        if let primaryUsagePage {
            fields.append("usagePage=\(Self.hex(primaryUsagePage))")
        }
        if let primaryUsage {
            fields.append("usage=\(Self.hex(primaryUsage))")
        }

        return fields.isEmpty ? "No allowlisted metadata was reported." : fields.joined(separator: ", ")
    }

    private static func hex(_ value: UInt16) -> String {
        String(format: "0x%04X", value)
    }
}

struct HIDRawProperties: Sendable {
    let productName: String?
    let manufacturer: String?
    let transport: String?
    let vendorID: Int?
    let productID: Int?
    let primaryUsagePage: Int?
    let primaryUsage: Int?

    // These fields exist only to make the privacy boundary explicit in tests.
    // System discovery never requests them and sanitized observations omit them.
    let serialNumber: String?
    let locationID: Int?

    init(
        productName: String? = nil,
        manufacturer: String? = nil,
        transport: String? = nil,
        vendorID: Int? = nil,
        productID: Int? = nil,
        primaryUsagePage: Int? = nil,
        primaryUsage: Int? = nil,
        serialNumber: String? = nil,
        locationID: Int? = nil
    ) {
        self.productName = productName
        self.manufacturer = manufacturer
        self.transport = transport
        self.vendorID = vendorID
        self.productID = productID
        self.primaryUsagePage = primaryUsagePage
        self.primaryUsage = primaryUsage
        self.serialNumber = serialNumber
        self.locationID = locationID
    }
}

private enum HIDMetadataSanitizer {
    private static let maximumTextLength = 96

    static func text(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let scalars = value.unicodeScalars.filter { scalar in
            !CharacterSet.controlCharacters.contains(scalar)
        }
        let cleaned = String(String.UnicodeScalarView(scalars))
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else {
            return nil
        }

        return String(cleaned.prefix(maximumTextLength))
    }

    static func identifier(_ value: Int?) -> UInt16? {
        guard let value else {
            return nil
        }

        return UInt16(exactly: value)
    }
}
