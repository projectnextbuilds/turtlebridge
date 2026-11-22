import Testing
@testable import TurtleBridgeKit

@Suite("Rematch 36-byte input report")
struct RematchInputReportTests {
    // Derived from the recorded 36-byte report with masked digital bits 0000.
    // Normalize the sequence to 1 and zero-fill unretained bytes. This is a test
    // fixture, not a lossless copy of the hardware transfer (see docs/REMATCH_INPUT.md).
    private let observed: [UInt8] = [0x20, 0x00, 0x01, 0x20, 0x00, 0x00]
        + [UInt8](repeating: 0, count: 30)

    @Test func observedButtonMask() {
        #expect(RematchInputReport(bytes: observed)?.digitalButtonBits == 0)
    }

    @Test func rejectsTruncatedAndOversizedTransfers() {
        for length in 0..<36 {
            #expect(RematchInputReport(bytes: Array(observed.prefix(length))) == nil)
        }
        for length in [37, 64, 65, 4096] {
            #expect(RematchInputReport(bytes: observed + [UInt8](repeating: 0, count: length - 36)) == nil)
        }
    }

    @Test func rejectsUnknownHeaders() {
        for (offset, value): (Int, UInt8) in [(0, 2), (0, 0x26), (1, 1), (1, 0x20),
                                             (1, 0x80), (2, 0), (3, 14), (3, 31), (3, 33)] {
            var bytes = observed
            bytes[offset] = value
            #expect(RematchInputReport(bytes: bytes) == nil)
        }
    }

    @Test func readsOnlyTheMaskedLittleEndianWord() {
        var synthetic = observed
        synthetic[2] = 255
        synthetic[4] = 0x13
        synthetic[5] = 0x80
        for index in 6..<synthetic.count { synthetic[index] = 0xff }
        #expect(RematchInputReport(bytes: synthetic)?.digitalButtonBits == 0x8010)
    }
}
