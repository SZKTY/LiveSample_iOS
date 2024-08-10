//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/06/24.
//

import Foundation
import Dependencies
import DependenciesMacros
import UIKit

@DependencyClient
public struct SNSClient: Sendable {
    public var shareInstagramStorie: @Sendable (_ stickerImage: Data,
                                                _ backgroundTopColor: String,
                                                _ backgroundBottomColor: String,
                                                _ contentURL: URL) async throws -> Void
    
    public var showShareView: (_ imageData: Data) -> Void
}

extension SNSClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var snsClient: SNSClient {
        get { self[SNSClient.self] }
        set { self[SNSClient.self] = newValue }
    }
}

extension SNSClient: DependencyKey {
    public static var liveValue: SNSClient = .request()
    
    static func request() -> Self {
        .init(
            shareInstagramStorie: { stickerImage, backgroundTopColor, backgroundBottomColor, contentURL  in
                try await StoriesClient.share(
                    stickerImageData: stickerImage,
                    backgroundTopColor: backgroundTopColor,
                    backgroundBottomColor: backgroundBottomColor,
                    contentURL: contentURL
                )
            },
            showShareView: { imageData in
                // アプリ名？
                let description = "setsumeibun ga hairimasu"
                // ストアリンク？
                let url = URL(string: "https://qiita.com/shiz/items/93a33446f289a8a9b65d")!
                let item = ShareActivityItemSource(imageData, title: description, url: url)
                let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
                let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                let viewController = scene?.keyWindow?.rootViewController
                let topVC = viewController?.topViewController()
                topVC?.present(activityViewController, animated: true, completion: nil)
            }
        )
    }
}

public struct StoriesClient {
    static private let appID = "8639096149452560"
    
    static private var urlScheme: URL? {
        URL(string: "instagram-stories://share?source_application=\(appID)")
    }
    
    private enum OptionsKey: String {
        case stickerImage = "com.instagram.sharedSticker.stickerImage"
        case backgroundImage = "com.instagram.sharedSticker.backgroundImage"
        case backgroundVideo = "com.instagram.sharedSticker.backgroundVideo"
        case backgroundTopColor = "com.instagram.sharedSticker.backgroundTopColor"
        case backgroundBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
        case contentURL = "com.instagram.sharedSticker.contentURL"
    }
    
    enum InstagramError: LocalizedError {
        case missingURLScheme
        case missingStickerImageData
        case couldNotOpenInstagram
    }
    
    static public func share(
        stickerImageData: Data,
        backgroundTopColor: String,
        backgroundBottomColor: String,
        contentURL: URL
    ) async throws {
        guard let urlScheme else {
            throw InstagramError.missingURLScheme
        }
        var items: [String: Any] = [:]
        items[OptionsKey.stickerImage.rawValue] = stickerImageData
        items[OptionsKey.backgroundTopColor.rawValue] = backgroundTopColor
        items[OptionsKey.backgroundBottomColor.rawValue] = backgroundBottomColor
        
        guard await UIApplication.shared.canOpenURL(urlScheme) else {
            throw InstagramError.couldNotOpenInstagram
        }
        
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
        UIPasteboard.general.setItems([items], options: pasteboardOptions)
        
        Task { @MainActor in
            await UIApplication.shared.open(urlScheme)
        }
    }
}

extension UIViewController {
    func topViewController() -> UIViewController? {
        if let splitViewController = self as? UISplitViewController {
            return splitViewController.viewController(for: .secondary)?.topViewController()
        }
        
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController()
        }
        
        if let presented = self.presentedViewController {
            return presented.topViewController()
        }
        
        return self
    }
}
