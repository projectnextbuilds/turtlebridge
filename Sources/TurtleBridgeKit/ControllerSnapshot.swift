public enum ControllerConnectionStatus: String, Equatable, Sendable {
    case notConnected = "Not connected"
    case discovering = "Discovering"
    case observed = "Interface observed"
    case connected = "Connected"
    case unavailable = "Unavailable"
}

public struct ControllerSnapshot: Equatable, Sendable {
    public let status: ControllerConnectionStatus
    public let deviceName: String?
    public let detail: String

    public init(
        status: ControllerConnectionStatus,
        deviceName: String? = nil,
        detail: String
    ) {
        self.status = status
        self.deviceName = deviceName
        self.detail = detail
    }

    public static let placeholder = ControllerSnapshot(
        status: .notConnected,
        detail: "Select Scan USB/HID to enumerate allowlisted interface metadata."
    )

    public var displayName: String {
        guard let deviceName, !deviceName.isEmpty else {
            return "No verified controller"
        }

        return deviceName
    }
}
