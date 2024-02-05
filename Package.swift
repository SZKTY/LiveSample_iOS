// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiveSample",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Sample", targets: ["Sample"]),
        .library(name: "TicketFeature", targets: ["TicketFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.45.0")
    ],
    targets: [
        .target(
            name: "Sample",
            dependencies: []
        ),
        .target(
            name: "TicketFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "TicketFeatureTest",
            dependencies: [
                "TicketFeature"
            ]
        )
    ]
)
