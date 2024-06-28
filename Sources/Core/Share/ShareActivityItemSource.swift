//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/06/28.
//

import Foundation
import UIKit
import LinkPresentation

public final class ShareActivityItemSource: NSObject, UIActivityItemSource {
    private let linkMetadata: LPLinkMetadata = LPLinkMetadata()
    
    public init(_ imageData: Data, title: String, url: URL) {
        super.init()
        
        if let uiImage = UIImage(data: imageData) {
            linkMetadata.iconProvider = NSItemProvider(object: uiImage)
            linkMetadata.imageProvider = NSItemProvider(object: uiImage)
        }
        
        linkMetadata.title = title
        linkMetadata.url = url
    }
    
    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetadata
    }
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return linkMetadata.title as Any
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController,
                                       itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        switch activityType {
        case UIActivity.ActivityType.postToFacebook:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.postToTwitter:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.mail:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.copyToPasteboard:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.message:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.postToFlickr:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.postToTencentWeibo:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.postToVimeo:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType.print:
            return linkMetadata.iconProvider
        case UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"):
            return linkMetadata.iconProvider
        case UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"):
            return linkMetadata.iconProvider
        case UIActivity.ActivityType(rawValue: "com.burbn.instagram.shareextension"):
            return linkMetadata.iconProvider
        case UIActivity.ActivityType(rawValue: "jp.naver.line.Share"):
            return linkMetadata.iconProvider
        default:
            return linkMetadata.iconProvider
            
        }
    }
}
