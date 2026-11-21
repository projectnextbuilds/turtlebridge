import Testing
@testable import TurtleBridgeKit

@Suite("Diagnostic capture")
struct DiagnosticCaptureTests {
    @Test("Capture is off by default")
    func offByDefault() {
        var capture = DiagnosticCapture()

        capture.recordScanStarted()
        capture.recordScanCompleted(matchingInterfaceCount: 1)
        capture.recordScanFailed()

        #expect(!capture.isEnabled)
        #expect(capture.entries.isEmpty)
        #expect(capture.formattedText == DiagnosticCapture.formatHeader)
    }

    @Test("Fake scan counts produce deterministic lifecycle events")
    func deterministicLifecycle() {
        var capture = DiagnosticCapture()
        capture.start()

        for count in [0, 2, 2, 0, 1] {
            capture.recordScanStarted()
            capture.recordScanCompleted(matchingInterfaceCount: count)
        }
        capture.stop()

        let lifecycleEvents = capture.entries.map(\.event).filter {
            [.interfacesAppeared, .interfacesDisappeared, .interfaceCountChanged].contains($0)
        }

        #expect(
            lifecycleEvents == [
                .interfacesAppeared,
                .interfacesDisappeared,
                .interfacesAppeared
            ]
        )
        #expect(!capture.isEnabled)
    }

    @Test("Counts and retained entries are bounded")
    func boundedOutput() {
        var capture = DiagnosticCapture()
        capture.start()
        capture.recordScanCompleted(matchingInterfaceCount: -1)
        capture.recordScanCompleted(matchingInterfaceCount: 100_000)

        #expect(capture.formattedText.contains("interfaces=0"))
        #expect(capture.formattedText.contains("interfaces=999"))
        #expect(!capture.formattedText.contains("interfaces=100000"))

        for _ in 0..<100 {
            capture.recordScanStarted()
        }

        #expect(capture.entries.count == DiagnosticCapture.maximumEntries)
        #expect(capture.formattedText.split(separator: "\n").allSatisfy { $0.count < 96 })
    }

    @Test("Format exposes no free-form identifier fields")
    func controlledFormat() {
        var capture = DiagnosticCapture()
        capture.start()
        capture.recordScanStarted()
        capture.recordScanFailed()
        capture.stop()

        let output = capture.formattedText.lowercased()

        #expect(output.hasPrefix("turtlebridge diagnostics v1"))
        #expect(!output.contains("serial"))
        #expect(!output.contains("hostname"))
        #expect(!output.contains("username"))
        #expect(!output.contains("path="))
        #expect(!output.contains("device="))
    }
}
