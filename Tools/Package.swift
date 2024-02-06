// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [
      .iOS(.v15),
      .macOS(.v14),
    ],
    dependencies: [
        .package(
            url: "https://github.com/realm/SwiftLint",
            branch: "main"),
    ],
    targets: [.target(name: "Tools", path: "")]
)
