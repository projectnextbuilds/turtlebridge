import Foundation
import IOKit

public enum USBDiscoveryError: Error, Equatable, Sendable {
    case matchingServicesFailed(code: Int32)
}

public protocol USBDiscovering: Sendable {
    func scan() throws -> [USBDeviceObservation]
}

public struct SystemUSBDiscovery: USBDiscovering {
    private let target: USBDeviceTarget

    public init(target: USBDeviceTarget) {
        self.target = target
    }

    public func scan() throws -> [USBDeviceObservation] {
        var iterator: io_iterator_t = 0
        let result = IOServiceGetMatchingServices(
            kIOMainPortDefault,
            IOServiceMatching("IOUSBHostDevice"),
            &iterator
        )

        guard result == KERN_SUCCESS else {
            throw USBDiscoveryError.matchingServicesFailed(code: result)
        }
        defer {
            IOObjectRelease(iterator)
        }

        var observations: [USBDeviceObservation] = []
        var service = IOIteratorNext(iterator)

        while service != 0 {
            let vendorID = Self.integerProperty("idVendor", service: service)
            let productID = Self.integerProperty("idProduct", service: service)
            let identity = USBRawProperties(vendorID: vendorID, productID: productID)

            if target.matches(identity) {
                let properties = Self.properties(
                    for: service,
                    vendorID: vendorID,
                    productID: productID
                )
                observations.append(USBDeviceObservation(rawProperties: properties))
            }

            IOObjectRelease(service)
            service = IOIteratorNext(iterator)
        }

        return observations.sorted { left, right in
            (left.productName ?? "") < (right.productName ?? "")
        }
    }

    private static func properties(
        for service: io_registry_entry_t,
        vendorID: Int?,
        productID: Int?
    ) -> USBRawProperties {
        USBRawProperties(
            productName: stringProperty("USB Product Name", service: service),
            manufacturer: stringProperty("USB Vendor Name", service: service),
            vendorID: vendorID,
            productID: productID,
            deviceClass: integerProperty("bDeviceClass", service: service),
            deviceSubclass: integerProperty("bDeviceSubClass", service: service),
            deviceProtocol: integerProperty("bDeviceProtocol", service: service)
        )
    }

    private static func stringProperty(_ key: String, service: io_registry_entry_t) -> String? {
        property(key, service: service) as? String
    }

    private static func integerProperty(_ key: String, service: io_registry_entry_t) -> Int? {
        (property(key, service: service) as? NSNumber)?.intValue
    }

    private static func property(_ key: String, service: io_registry_entry_t) -> AnyObject? {
        IORegistryEntryCreateCFProperty(
            service,
            key as CFString,
            kCFAllocatorDefault,
            0
        )?.takeRetainedValue()
    }
}
