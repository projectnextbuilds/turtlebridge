extension ControllerSnapshot {
    public static var discoveringTarget: Self {
        Self(status: .discovering, detail: "Looking for the Rematch USB connection.")
    }

    public static func targetConnection(using discovery: any USBDiscovering) -> Self {
        do {
            let devices = try discovery.scan()
            switch devices.count {
            case 0:
                return Self(status: .notConnected, detail: "The Rematch USB device is disconnected.")
            case 1:
                return Self(status: .connected, deviceName: devices[0].displayName,
                            detail: "Connected over USB. Waiting for verified controller input.")
            default:
                return Self(status: .unavailable, detail: "Multiple matching controllers are connected.")
            }
        } catch {
            return Self(status: .unavailable, detail: "The USB connection could not be checked.")
        }
    }
}
