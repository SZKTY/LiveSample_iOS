# LiveSample

## 開発の始め方

1. Xcode を開いて、 `./Package.swift` を選択します
2. 修正の必要なファイルを選択して、修正します

## モジュールを追加したいとき

1. `./Package.swift` を開き、新しい Feature 追加します ( `./Package.swift` 追記例を参考にしてください)
2. Xcode を開いて、 `App/LiveSample/LiveSample.xcodeproj` を選択
3. General > Frameworks, Libraries, and Embedded Content のところで「+」を押す
4. 新しい Feature を選択する
5. 完了

#### `./Package.swift` 追記例

新しく追加する機能を、下記では `NewFeature` としています.

```

let package = Package(
    ...
    products: [
        ...
        .library(name: "NewFeature", targets: ["NewFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.45.0")
    ],
    targets: [
        ...
        .target(
            name: "NewFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "NewFeatureTest",
            dependencies: [
                "NewFeature"
            ]
        )
    ]
)
```

※ ざっくり `target` はビルドする単位、 `product` は機能の単位

## 動作確認の仕方

1. Xcode を開いて、 `App/LiveSample/LiveSample.xcodeproj` を選択
2. 「▶️」を押す

## その他

- lint の掛け方

```
swift run -c release --package-path Tools swiftlint --fix --format
swift run -c release --package-path Tools swiftlint
```

- test の走らせ方

```
swift test --filter {パッケージ名}
swift test --filter TicketFeature
```
