//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/08/12.
//

import Foundation

public struct Constants {
    public static var shared: Constants = .init()
    
    private init() {}
    
    public let privacyPolicyUrl: URL = .init(string: "https://congruous-painter-ef2.notion.site/SPREET-e865e888ab214a5ebe025f2666589b53")!
    public let termOfServiceUrl: URL = .init(string: "https://congruous-painter-ef2.notion.site/SPREET-957bdb72d58d4c18a56014e5a6f15d3b")!
    public var heplUrl: URL?
    public var contactUrl: URL?
}
