/// Digital bitfield from the 36-byte primary gamepad input format observed on TBC-2001-75.
public struct RematchInputReport: Equatable, Sendable {
    public let digitalButtonBits: UInt16

    /// The caller supplies one whole transfer from the matched controller on endpoint 0x81.
    public init?(bytes: [UInt8]) {
        guard bytes.count == 36, bytes[0] == 0x20, bytes[1] == 0,
              bytes[2] != 0, bytes[3] == 32 else { return nil }

        // Exclude the reserved and keep-alive bits, as in the physical sampler.
        digitalButtonBits = UInt16(bytes[4] & 0xfc) | (UInt16(bytes[5]) << 8)
    }
}
