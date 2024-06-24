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
public struct InstagramClient: Sendable {
    public var shareStorie: @Sendable (_ stickerImage: Data,
                                       _ backgroundTopColor: String,
                                       _ backgroundBottomColor: String,
                                       _ contentURL: URL) async throws -> Void
}

extension InstagramClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var instagramClient: InstagramClient {
        get { self[InstagramClient.self] }
        set { self[InstagramClient.self] = newValue }
    }
}

extension InstagramClient: DependencyKey {
    public static var liveValue: InstagramClient = .request()
    
    static func request() -> Self {
        .init(
            shareStorie: { stickerImage, backgroundTopColor, backgroundBottomColor, contentURL  in
                try await StoriesClient.share(
                    stickerImageData: stickerImage,
                    backgroundTopColor: backgroundTopColor,
                    backgroundBottomColor: backgroundBottomColor,
                    contentURL: contentURL
                )
            }
        )
    }
}

public struct StoriesClient {
    // TODO: 正しい「アプリID」に置き換える
    static private let appID = "123456789"
    
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
        items[OptionsKey.contentURL.rawValue] = contentURL.absoluteString
        
        guard await UIApplication.shared.canOpenURL(urlScheme) else {
            throw InstagramError.couldNotOpenInstagram
        }
        
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
        UIPasteboard.general.setItems([items], options: pasteboardOptions)
        await UIApplication.shared.open(urlScheme)
    }
}
