// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


// MARK: - Library
typealias PackageDependency = PackageDescription.Package.Dependency
typealias TargetDependency = PackageDescription.Target.Dependency
typealias Target = PackageDescription.Target
typealias Product = PackageDescription.Product

let packageDependencies: [PackageDependency] = [
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: .init(10, 11, 0)),
    .package(url: "https://github.com/yazio/ReadabilityModifier", from: .init(1, 0, 0)),
    .package(url: "https://github.com/exyte/PopupView", from: .init(2, 5, 7)),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: .init(1, 2, 0)),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: .init(1, 1, 0)),
    .package(url: "https://github.com/TimOliver/TOCropViewController.git", from: .init(2, 6, 1)),
    .package(url: "https://github.com/kean/Nuke.git", from: .init(12, 1, 5))
]

let readabilityModifier: TargetDependency = .product(name: "ReadabilityModifier", package: "ReadabilityModifier")
let analytics: TargetDependency = .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
let popupView: TargetDependency = .product(name: "PopupView", package: "PopupView")
let composableArchitecture: TargetDependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let dependencies: TargetDependency = .product(name: "Dependencies", package: "swift-dependencies")
let dependenciesMacros: TargetDependency = .product(name: "DependenciesMacros", package: "swift-dependencies")
let cropViewController: TargetDependency = .product(name: "CropViewController", package: "TOCropViewController")
let nuke: TargetDependency = .product(name: "Nuke", package: "Nuke")

extension Target {
    static func core(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/Core/\(name)", resources: resources, plugins: plugins)
    }

    static func feature(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/Feature/\(name)", resources: resources, plugins: plugins)
    }
    
    static func featureStore(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/FeatureStore/\(name)", resources: resources, plugins: plugins)
    }

    static func entity(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/Entity/\(name)", resources: resources, plugins: plugins)
    }

    static func data(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/Data/\(name)", resources: resources, plugins: plugins)
    }

    static func featureTest(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .testTarget(name: name, dependencies: dependencies, path: "Tests/Feature/\(name)", resources: resources, plugins: plugins)
    }

    // TODO: - test に統合
    static func dataTest(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .testTarget(name: name, dependencies: dependencies, path: "Tests/Data/\(name)", resources: resources, plugins: plugins)
    }
    
    static func sample(name: String, dependencies: [TargetDependency], resources: [Resource]? = nil, plugins: [Target.PluginUsage]? = nil) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/Sample/\(name)", resources: resources, plugins: plugins)
    }
}

let coreTargets: [Target] = [
    .core(name: "ViewComponents", dependencies: []),
    .core(name: "Routing", dependencies: [
        "AccountIdStore",
        "AccountNameStore",
        "HomeStore",
        "MailAddressPasswordStore",
        "ProfileImageStore",
        "RootStore",
        "SelectModeStore",
        "WelcomeStore",
        "User",
        composableArchitecture,
        dependencies,
        dependenciesMacros,
    ])
]

let entityTargets: [Target] = [
    .entity(name: "User", dependencies: [])
]

let featureTargets: [Target] = [
    .feature(name: "AccountId", dependencies: [
        "AccountIdStore",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "AccountName", dependencies: [
        "AccountNameStore",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "Home", dependencies: [
        "HomeStore",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "MailAddressPassword", dependencies: [
        "MailAddressPasswordStore",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "ProfileImage", dependencies: [
        "ProfileImageStore",
        "ViewComponents",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "Root", dependencies: [
        "RootStore",
        "Welcome",
        "WelcomeStore",
        "Home",
        "HomeStore",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "SelectMode", dependencies: [
        "SelectModeStore",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "Welcome", dependencies: [
        "WelcomeStore",
        "Routing",
        composableArchitecture,
        dependencies
    ])
]

let featureStoreTargets: [Target] = [
    .featureStore(name: "AccountIdStore", dependencies: [
        "User",
        "AccountNameStore",
        composableArchitecture
    ]),
    .featureStore(name: "AccountNameStore", dependencies: [
        "User",
        "ProfileImageStore",
        composableArchitecture
    ]),
    .featureStore(name: "HomeStore", dependencies: [
        composableArchitecture
    ]),
    .featureStore(name: "MailAddressPasswordStore", dependencies: [
        "AccountIdStore",
        composableArchitecture
    ]),
    .featureStore(name: "ProfileImageStore", dependencies: [
        "User",
        "SelectModeStore",
        composableArchitecture,
    ]),
    .featureStore(name: "RootStore", dependencies: [
        composableArchitecture
    ]),
    .featureStore(name: "SelectModeStore", dependencies: [
        "User",
        composableArchitecture
    ]),
    .featureStore(name: "WelcomeStore", dependencies: [
        "MailAddressPasswordStore",
        composableArchitecture
    ])
]

let sampleTargets: [Target] = [
    .sample(name: "SampleCounter", dependencies: [
        composableArchitecture
    ])
]

// MARK: - Package
let allTargets = coreTargets + entityTargets + featureTargets + featureStoreTargets + sampleTargets

let package = Package(
    name: "LiveSample",
    platforms: [.iOS(.v16)],
    products: allTargets
        .filter { $0.isTest == false }   // Do not Inclued Test In Package For Release 
        .map{ $0.name }
        .map{ .library(name: $0, targets: [$0]) },
    dependencies: packageDependencies,
    targets: allTargets
)
