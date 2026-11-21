public enum DiagnosticEventKind: String, Equatable, Sendable {
    case captureStarted = "capture-started"
    case scanStarted = "scan-started"
    case scanCompleted = "scan-completed"
    case interfacesAppeared = "interfaces-appeared"
    case interfacesDisappeared = "interfaces-disappeared"
    case interfaceCountChanged = "interface-count-changed"
    case scanFailed = "scan-failed"
    case captureStopped = "capture-stopped"
}

public struct DiagnosticEntry: Equatable, Sendable {
    public let sequence: UInt
    public let event: DiagnosticEventKind
    public let matchingInterfaceCount: UInt16?

    public var formattedLine: String {
        let sequenceText = String(sequence)
        let paddedSequence = String(
            repeating: "0",
            count: max(0, 4 - sequenceText.count)
        ) + sequenceText
        let prefix = "\(paddedSequence) event=\(event.rawValue)"
        guard let matchingInterfaceCount else {
            return prefix
        }

        return "\(prefix) interfaces=\(matchingInterfaceCount)"
    }
}

public struct DiagnosticCapture: Equatable, Sendable {
    public static let formatHeader = "TurtleBridge diagnostics v1"
    public static let maximumEntries = 64
    public static let maximumInterfaceCount = 999

    public private(set) var isEnabled = false
    public private(set) var entries: [DiagnosticEntry] = []

    private var nextSequence: UInt = 1
    private var previousInterfaceCount: UInt16?

    public init() {}

    public mutating func start() {
        entries.removeAll(keepingCapacity: true)
        nextSequence = 1
        previousInterfaceCount = nil
        isEnabled = true
        append(.captureStarted)
    }

    public mutating func stop() {
        guard isEnabled else {
            return
        }

        append(.captureStopped)
        isEnabled = false
    }

    public mutating func recordScanStarted() {
        guard isEnabled else {
            return
        }

        append(.scanStarted)
    }

    public mutating func recordScanCompleted(matchingInterfaceCount: Int) {
        guard isEnabled else {
            return
        }

        let count = Self.boundedInterfaceCount(matchingInterfaceCount)
        append(.scanCompleted, matchingInterfaceCount: count)

        if let previousInterfaceCount {
            switch (previousInterfaceCount, count) {
            case (0, 1...):
                append(.interfacesAppeared, matchingInterfaceCount: count)
            case (1..., 0):
                append(.interfacesDisappeared, matchingInterfaceCount: count)
            case let (previous, current) where previous != current:
                append(.interfaceCountChanged, matchingInterfaceCount: count)
            default:
                break
            }
        }

        previousInterfaceCount = count
    }

    public mutating func recordScanFailed() {
        guard isEnabled else {
            return
        }

        append(.scanFailed)
    }

    public var formattedText: String {
        ([Self.formatHeader] + entries.map(\.formattedLine)).joined(separator: "\n")
    }

    private mutating func append(
        _ event: DiagnosticEventKind,
        matchingInterfaceCount: UInt16? = nil
    ) {
        entries.append(
            DiagnosticEntry(
                sequence: nextSequence,
                event: event,
                matchingInterfaceCount: matchingInterfaceCount
            )
        )
        nextSequence += 1

        if entries.count > Self.maximumEntries {
            entries.removeFirst(entries.count - Self.maximumEntries)
        }
    }

    private static func boundedInterfaceCount(_ value: Int) -> UInt16 {
        UInt16(min(max(value, 0), maximumInterfaceCount))
    }
}
