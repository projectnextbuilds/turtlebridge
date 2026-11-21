import Foundation
import IOKit.hid

public enum HIDDiscoveryError: Error, Equatable, Sendable {
    case managerOpenFailed(code: Int32)
}

public protocol HIDDiscovering: Sendable {
    func scan() throws -> [HIDDeviceObservation]
}

public struct SystemHIDDiscovery: HIDDiscovering {
    public init() {}

    public func scan() throws -> [HIDDeviceObservation] {
        let manager = IOHIDManagerCreate(
            kCFAllocatorDefault,
            IOOptionBits(kIOHIDOptionsTypeNone)
        )

        IOHIDManagerSetDeviceMatchingMultiple(manager, Self.gameControllerMatches as CFArray)

        let openResult = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        guard openResult == kIOReturnSuccess else {
            throw HIDDiscoveryError.managerOpenFailed(code: openResult)
        }
        defer {
            IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        }

        guard let deviceSet = IOHIDManagerCopyDevices(manager) else {
            return []
        }

        let devices = (deviceSet as NSSet).allObjects.map { object in
            object as! IOHIDDevice
        }
        return devices
            .map(Self.observation)
            .sorted(by: Self.sortObservations)
    }

    private static let gameControllerMatches: [[String: Int]] = [
        [
            kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
            kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick
        ],
        [
            kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
            kIOHIDDeviceUsageKey: kHIDUsage_GD_GamePad
        ],
        [
            kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
            kIOHIDDeviceUsageKey: kHIDUsage_GD_MultiAxisController
        ]
    ]

    private static func observation(for device: IOHIDDevice) -> HIDDeviceObservation {
        let rawProperties = HIDRawProperties(
            productName: stringProperty(kIOHIDProductKey, device: device),
            manufacturer: stringProperty(kIOHIDManufacturerKey, device: device),
            transport: stringProperty(kIOHIDTransportKey, device: device),
            vendorID: integerProperty(kIOHIDVendorIDKey, device: device),
            productID: integerProperty(kIOHIDProductIDKey, device: device),
            primaryUsagePage: integerProperty(kIOHIDPrimaryUsagePageKey, device: device),
            primaryUsage: integerProperty(kIOHIDPrimaryUsageKey, device: device)
        )

        return HIDDeviceObservation(rawProperties: rawProperties)
    }

    private static func stringProperty(_ key: String, device: IOHIDDevice) -> String? {
        IOHIDDeviceGetProperty(device, key as CFString) as? String
    }

    private static func integerProperty(_ key: String, device: IOHIDDevice) -> Int? {
        (IOHIDDeviceGetProperty(device, key as CFString) as? NSNumber)?.intValue
    }

    private static func sortObservations(
        _ left: HIDDeviceObservation,
        _ right: HIDDeviceObservation
    ) -> Bool {
        let leftKey = (
            left.productName ?? "",
            left.vendorID ?? 0,
            left.productID ?? 0,
            left.primaryUsage ?? 0
        )
        let rightKey = (
            right.productName ?? "",
            right.vendorID ?? 0,
            right.productID ?? 0,
            right.primaryUsage ?? 0
        )

        return leftKey < rightKey
    }
}
