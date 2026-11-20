// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TurtleBridge",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "TurtleBridge", targets: ["TurtleBridge"]),
        .library(name: "TurtleBridgeKit", targets: ["TurtleBridgeKit"])
    ],
    targets: [
        .executableTarget(
            name: "TurtleBridge",
            dependencies: ["TurtleBridgeKit"]
        ),
        .target(name: "TurtleBridgeKit"),
        .testTarget(
            name: "TurtleBridgeKitTests",
            dependencies: ["TurtleBridgeKit"]
        )
    ]
)
