# プロジェクト構成

プロジェクト構成については以下のことを考慮して、[isowords](https://github.com/pointfreeco/isowords/)を参考にした構成を採用します。

- マルチモジュールで依存関係を明確にしたいため
- SwiftPackageManager がデファクトスタンダードになってきたため
  - Xcodegen の脱却

## 参考資料

- [isowords に学ぶプロジェクト構成](https://www.notion.so/isowords-8f8982eb3a9a4665b2fa688b06791b70)
- [pointfreeco/isowords のコードリーディング](https://zenn.dev/yimajo/scraps/591dbf1ea6a434)
- [Swift PM とマルチプロジェクトで Build Configuration をクリーンに保つ](https://www.notion.so/Swift-PM-Build-Configuration-4f14ceac795a4338a5a44748adfeaa40)
- [Xcode プロジェクトにローカルの SwiftPackage を追加する](https://daisuke-t-jp.hatenablog.com/entry/2021/04/27/using-local-swift-package)
