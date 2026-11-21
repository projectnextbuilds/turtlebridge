# Sanitized diagnostics

TurtleBridge diagnostics are a local, opt-in investigation aid. They are off by default and have no analytics, telemetry, remote upload, or background collection.

## Start and stop capture

1. Select **Start diagnostics**. Starting a new capture clears the previous in-memory session.
2. Select **Scan USB/HID** at each documented lifecycle step.
3. Select **Stop diagnostics** when the sequence is complete.
4. Review every line before selecting and copying only the portion needed for a report.

Closing the app discards the capture. TurtleBridge does not write diagnostic sessions to disk.

## Version 1 format

The first line identifies the format:

```text
TurtleBridge diagnostics v1
```

Every following line contains a local sequence number, a controlled event name, and, when applicable, a bounded count of matching HID interfaces:

```text
0001 event=capture-started
0002 event=scan-started
0003 event=scan-completed interfaces=0
0004 event=capture-stopped
```

Supported events are:

- `capture-started`
- `scan-started`
- `scan-completed`
- `interfaces-appeared`
- `interfaces-disappeared`
- `interface-count-changed`
- `scan-failed`
- `capture-stopped`

The capture retains at most 64 entries. Interface counts are constrained to the range 0 through 999. Entries contain no timestamps or free-form values.

## Privacy boundary

The diagnostic API accepts only controlled events and interface counts. It has no field for device names, manufacturer names, vendor or product IDs, serial numbers, USB location identifiers, registry identifiers, usernames, account names, hostnames, local paths, or raw reports.

The regular discovery view may separately display allowlisted, non-unique interface metadata. Do not include that metadata in a report unless it is needed, reviewed, and within the documented test scope.

## Sharing a capture

Before sharing diagnostic text:

1. confirm the header is `TurtleBridge diagnostics v1`;
2. confirm every line contains only a sequence, controlled event, and optional interface count;
3. describe the connection state for each scan separately in the issue or test record;
4. remove unrelated screenshots, window titles, terminal output, and system information; and
5. share the minimum lines needed to reproduce the observation.

Diagnostic output is an observation aid. It is not proof that input reports are readable or that a controller, game, launcher, emulator, or cloud service is compatible.
