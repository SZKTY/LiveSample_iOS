// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiveSample",
    platforms: [
        .iOS(.v15),
        .macOS(.v14)
    ],
    products: [
        .library(name: "Sample",
                 targets: ["Sample"]),
        .library(name: "Counter",
                 targets: ["Sample"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            branch: "main")
    ],
    targets: [
        .target(
            name: "Sample",
            dependencies: [
                .product(name: "ComposableArchitecture",
                         package: "swift-composable-architecture")
            ]
        )
    ]
)
