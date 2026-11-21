import Foundation
import IOKit.hid

let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0)
let target: [String: Any] = [
    kIOHIDVendorIDKey: 0xFFFF,
    kIOHIDProductIDKey: 0x5452,
    kIOHIDProductKey: "TurtleBridge Feasibility Gamepad",
    kIOHIDDeviceUsagePageKey: 1,
    kIOHIDDeviceUsageKey: 5
]
IOHIDManagerSetDeviceMatching(manager, target as CFDictionary)
IOHIDManagerRegisterDeviceMatchingCallback(manager, { _, status, _, _ in
    if status == kIOReturnSuccess { print("consumer_match=true") }
}, nil)
IOHIDManagerRegisterInputReportCallback(manager, { _, status, _, type, reportID, bytes, size in
    if status == kIOReturnSuccess && type == kIOHIDReportTypeInput &&
        reportID == 0 && size == 1 && bytes[0] == 0 {
        print("consumer_neutral_report=true")
    }
}, nil)
IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
let status = IOHIDManagerOpen(manager, 0)
guard status == kIOReturnSuccess else {
    print("consumer_open_error=\(status)")
    exit(1)
}

print("consumer_ready=true")
fflush(stdout)
CFRunLoopRunInMode(.defaultMode, 6, false)
IOHIDManagerClose(manager, 0)
print("consumer_finished=true")
