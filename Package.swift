// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


// MARK: - Library
typealias PackageDependency = PackageDescription.Package.Dependency
typealias TargetDependency = PackageDescription.Target.Dependency
typealias Target = PackageDescription.Target
typealias Product = PackageDescription.Product

let packageDependencies: [PackageDependency] = [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: .init(1, 2, 0)),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: .init(1, 1, 0)),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: .init(10, 11, 0)),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
    .package(url: "https://github.com/exyte/PopupView", from: .init(2, 5, 7)),
    .package(url: "https://github.com/TimOliver/TOCropViewController.git", from: .init(2, 6, 1)),
    .package(url: "https://github.com/yazio/ReadabilityModifier", from: .init(1, 0, 0)),
    .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0"))
]

let composableArchitecture: TargetDependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let dependencies: TargetDependency = .product(name: "Dependencies", package: "swift-dependencies")
let dependenciesMacros: TargetDependency = .product(name: "DependenciesMacros", package: "swift-dependencies")
let analytics: TargetDependency = .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
let remoteConfig: TargetDependency = .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
let alamofire: TargetDependency = .product(name: "Alamofire", package: "Alamofire")
let popupView: TargetDependency = .product(name: "PopupView", package: "PopupView")
let cropViewController: TargetDependency = .product(name: "CropViewController", package: "TOCropViewController")
let readabilityModifier: TargetDependency = .product(name: "ReadabilityModifier", package: "ReadabilityModifier")
let Kingfisher: TargetDependency = .product(name: "Kingfisher", package: "Kingfisher")

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
    .core(name: "Assets",dependencies: []),
    .core(name: "DateUtils", dependencies: []),
    .core(name: "Location", dependencies: []),
    .core(name: "ViewComponents", dependencies: [
        "Assets",
        "Location",
        "PostAnnotation",
        "Share"
    ]),
    .core(name: "Validator", dependencies: []),
    .core(name: "Routing", dependencies: [
        "RootStore",
        "WelcomeStore",
        "MailAddressPasswordStore",
        "AccountIdNameStore",
        "ProfileImageStore",
        "SelectModeStore",
        "MapStore",
        "MyPageStore",
        "EditProfileStore",
        "PostStore",
        "PostDetailStore",
        "MapWithCrossStore",
        composableArchitecture,
        dependencies,
        dependenciesMacros,
    ]),
    .core(name: "Share", dependencies: [
        dependencies,
        dependenciesMacros
    ])
]

let dataTargets: [Target] = [
    .data(name: "API", dependencies: [
        "PostEntity",
        "Config",
        alamofire,
        remoteConfig,
        dependencies,
        dependenciesMacros
    ]),
    .data(name: "UserDefaults", dependencies: [
        dependencies,
        dependenciesMacros
    ])
]

let entityTargets: [Target] = [
    .entity(name: "Config", dependencies: []),
    .entity(name: "PostEntity", dependencies: []),
    .entity(name: "PostAnnotation", dependencies: [])
]

let featureTargets: [Target] = [
    .feature(name: "AccountIdName", dependencies: [
        "AccountIdNameStore",
        "Assets",
        "ViewComponents",
        "Routing",
        composableArchitecture,
        dependencies,
        popupView
    ]),
    .feature(name: "MailAddressPassword", dependencies: [
        "MailAddressPasswordStore",
        "Assets",
        "ViewComponents",
        "Routing",
        composableArchitecture,
        dependencies,
        popupView
    ]),
    .feature(name: "ProfileImage", dependencies: [
        "ProfileImageStore",
        "Assets",
        "ViewComponents",
        "Routing",
        composableArchitecture,
        dependencies,
        popupView
    ]),
    .feature(name: "Root", dependencies: [
        analytics,
        "RootStore",
        "Welcome",
        "WelcomeStore",
        "Map",
        "MapStore",
        "Assets",
        "Routing",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "SelectMode", dependencies: [
        "SelectModeStore",
        "ViewComponents",
        "Routing",
        "Assets",
        composableArchitecture,
        dependencies,
        popupView
    ]),
    .feature(
        name: "Welcome",
        dependencies: [
            "WelcomeStore",
            "Routing",
            "Assets",
            composableArchitecture,
            dependencies
        ]
    ),
    .feature(name: "Map", dependencies: [
        "MapStore",
        "Routing",
        "ViewComponents",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "MyPage", dependencies: [
        "MyPageStore",
        "ViewComponents",
        composableArchitecture,
        dependencies
    ]),
    .feature(name: "EditProfile", dependencies: [
        "EditProfileStore",
        "Assets",
        "Routing",
        "ViewComponents",
        composableArchitecture,
        dependencies,
        popupView
    ]),
    .feature(name: "Post", dependencies: [
        "PostStore",
        "Assets",
        "Routing",
        "ViewComponents",
        composableArchitecture,
        dependencies,
        popupView
    ]),
    .feature(name: "PostDetail", dependencies: [
        "PostDetailStore",
        "Assets",
        "Share",
        "ViewComponents",
        composableArchitecture,
        Kingfisher
    ]),
    .feature(name: "MapWithCross", dependencies: [
        "MapWithCrossStore",
        "Routing",
        "ViewComponents",
        composableArchitecture,
        dependencies
    ])
]

let featureStoreTargets: [Target] = [
    .featureStore(name: "AccountIdNameStore", dependencies: [
        "API",
        "UserDefaults",
        "ProfileImageStore",
        composableArchitecture
    ]),
    .featureStore(name: "MailAddressPasswordStore", dependencies: [
        "API",
        "UserDefaults",
        "Validator",
        "AccountIdNameStore",
        "SelectModeStore",
        composableArchitecture
    ]),
    .featureStore(name: "ProfileImageStore", dependencies: [
        "API",
        "UserDefaults",
        "SelectModeStore",
        composableArchitecture,
    ]),
    .featureStore(name: "RootStore", dependencies: [
        "API",
        "Config",
        composableArchitecture
    ]),
    .featureStore(name: "SelectModeStore", dependencies: [
        "API",
        "UserDefaults",
        composableArchitecture
    ]),
    .featureStore(name: "WelcomeStore", dependencies: [
        "API",
        "UserDefaults",
        "MailAddressPasswordStore",
        "AccountIdNameStore",
        "SelectModeStore",
        composableArchitecture
    ]),
    .featureStore(name: "MapStore", dependencies: [
        "API",
        "UserDefaults",
        "PostStore",
        "PostDetailStore",
        "MyPageStore",
        "EditProfileStore",
        "PostAnnotation",
        composableArchitecture
    ]),
    .featureStore(name: "MyPageStore", dependencies: [
        "API",
        composableArchitecture
    ]),
    .featureStore(name: "EditProfileStore", dependencies: [
        "API",
        "UserDefaults",
        composableArchitecture
    ]),
    .featureStore(name: "PostStore", dependencies: [
        "DateUtils",
        "API",
        "UserDefaults",
        "PostEntity",
        "MapWithCrossStore",
        composableArchitecture
    ]),
    .featureStore(name: "PostDetailStore", dependencies: [
        "DateUtils",
        "Share",
        "API",
        "UserDefaults",
        "PostAnnotation",
        composableArchitecture
    ]),
    .featureStore(name: "MapWithCrossStore", dependencies: [
        composableArchitecture
    ])
]

let sampleTargets: [Target] = [
    .sample(name: "SampleCounter", dependencies: [
        composableArchitecture
    ])
]

// MARK: - Package
let allTargets = coreTargets + dataTargets + entityTargets + featureTargets + featureStoreTargets + sampleTargets

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
