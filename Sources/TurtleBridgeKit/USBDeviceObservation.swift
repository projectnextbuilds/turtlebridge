import Foundation

public struct USBDeviceTarget: Equatable, Sendable {
    public let vendorID: UInt16
    public let productID: UInt16

    public init(vendorID: UInt16, productID: UInt16) {
        self.vendorID = vendorID
        self.productID = productID
    }

    func matches(_ properties: USBRawProperties) -> Bool {
        USBMetadataSanitizer.identifier(properties.vendorID) == vendorID
            && USBMetadataSanitizer.identifier(properties.productID) == productID
    }
}

public struct USBDeviceObservation: Equatable, Sendable {
    public let productName: String?
    public let manufacturer: String?
    public let vendorID: UInt16?
    public let productID: UInt16?
    public let deviceClass: UInt8?
    public let deviceSubclass: UInt8?
    public let deviceProtocol: UInt8?

    init(rawProperties: USBRawProperties) {
        productName = USBMetadataSanitizer.text(rawProperties.productName)
        manufacturer = USBMetadataSanitizer.text(rawProperties.manufacturer)
        vendorID = USBMetadataSanitizer.identifier(rawProperties.vendorID)
        productID = USBMetadataSanitizer.identifier(rawProperties.productID)
        deviceClass = USBMetadataSanitizer.byte(rawProperties.deviceClass)
        deviceSubclass = USBMetadataSanitizer.byte(rawProperties.deviceSubclass)
        deviceProtocol = USBMetadataSanitizer.byte(rawProperties.deviceProtocol)
    }

    public var displayName: String {
        productName ?? "Observed target USB device"
    }

    public var diagnosticSummary: String {
        var fields: [String] = []

        if let manufacturer {
            fields.append("manufacturer=\(manufacturer)")
        }
        if let vendorID {
            fields.append("vendor=\(Self.hexWord(vendorID))")
        }
        if let productID {
            fields.append("product=\(Self.hexWord(productID))")
        }
        if let deviceClass {
            fields.append("class=\(Self.hexByte(deviceClass))")
        }
        if let deviceSubclass {
            fields.append("subclass=\(Self.hexByte(deviceSubclass))")
        }
        if let deviceProtocol {
            fields.append("protocol=\(Self.hexByte(deviceProtocol))")
        }

        return fields.isEmpty ? "No allowlisted USB metadata was reported." : fields.joined(separator: ", ")
    }

    private static func hexWord(_ value: UInt16) -> String {
        String(format: "0x%04X", value)
    }

    private static func hexByte(_ value: UInt8) -> String {
        String(format: "0x%02X", value)
    }
}

struct USBRawProperties: Sendable {
    let productName: String?
    let manufacturer: String?
    let vendorID: Int?
    let productID: Int?
    let deviceClass: Int?
    let deviceSubclass: Int?
    let deviceProtocol: Int?

    // These fields exist only to make the privacy boundary explicit in tests.
    // System discovery never requests them and sanitized observations omit them.
    let serialNumber: String?
    let locationID: Int?
    let registryPath: String?

    init(
        productName: String? = nil,
        manufacturer: String? = nil,
        vendorID: Int? = nil,
        productID: Int? = nil,
        deviceClass: Int? = nil,
        deviceSubclass: Int? = nil,
        deviceProtocol: Int? = nil,
        serialNumber: String? = nil,
        locationID: Int? = nil,
        registryPath: String? = nil
    ) {
        self.productName = productName
        self.manufacturer = manufacturer
        self.vendorID = vendorID
        self.productID = productID
        self.deviceClass = deviceClass
        self.deviceSubclass = deviceSubclass
        self.deviceProtocol = deviceProtocol
        self.serialNumber = serialNumber
        self.locationID = locationID
        self.registryPath = registryPath
    }
}

private enum USBMetadataSanitizer {
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

    static func byte(_ value: Int?) -> UInt8? {
        guard let value else {
            return nil
        }

        return UInt8(exactly: value)
    }
}
