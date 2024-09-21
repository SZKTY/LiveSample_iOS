//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/05/03.
//

import Foundation
import UIKit

public struct Config: Equatable {
    // メンテナンス
    public var maintenanceStartDate: String?
    public var maintenanceEndDate: String?
    public var maintenanceMessage: String?
    
    // 強制アップデート
    public var forceUpdateStartDate: String?
    public var forceUpdateEndDate: String?
    public var forceUpdateRequiredVersion: String?
    public var forceUpdateMessage: String?
    
    // AppleStoreのアプリURL
    public var storeUrl: String?
    
    // ヘルプURL
    public var helpUrl: String?
    // お問い合わせURL
    public var contactUrl: String?
    
    // アーティスト登録フォームURL
    public var artistRegisterFormUrl: String?
    
    public init() {}
}

// MARK: - extension
extension Config {
    public static func stub() -> Self {
        let conifg = Self()
        return conifg
    }
    
    public var isInMaintenance: Bool {
        let dateFormatter = DateFormatter.dateFormatterYMdHms()
        
        guard let startDateString = maintenanceStartDate,
              let startDate = dateFormatter.date(from: startDateString),
              let endDateString = maintenanceEndDate,
              let endDate = dateFormatter.date(from: endDateString) else {
            return false
        }
        
        let now = Date()
        if now > startDate && now < endDate {
            return true
        }
        
        return false
    }
    
    public var isInForceUpdate: Bool {
        let dateFormatter = DateFormatter.dateFormatterYMdHms()
        
        guard let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let requiredDeviceVersion = forceUpdateRequiredVersion,
              let startDateString = forceUpdateStartDate,
              let startDate = dateFormatter.date(from: startDateString),
              let endDateString = forceUpdateEndDate,
              let endDate = dateFormatter.date(from: endDateString) else {
            return false
        }
        
        let now = Date()
        let result = requiredDeviceVersion.compare(bundleVersion, options: [.numeric])
        
        if now > startDate && now < endDate && result == .orderedDescending {
            return true
        }
        
        return false
    }
    
    public func openURL(to urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL文字列が不正のため何もしない")
            return
        }
        
        UIApplication.shared.open(url)
    }
}

extension DateFormatter {
    fileprivate static func defaultFormat() -> Self {
        let formatter = Self()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .init(identifier: "Asia/Tokyo")
        return formatter
    }
    
    static func dateFormatterYMdHms() -> Self {
        let formatter = defaultFormat()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }
}
