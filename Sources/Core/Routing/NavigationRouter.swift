//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/19.
//

import Foundation

public class NavigationRouter: ObservableObject {
    @MainActor @Published public var items: [WelcomePath] = []
    
    public init() {}
    
    public enum WelcomePath {
        case welcome
        case mailAddressPassword
        case accountName
        case accountId
        case profileImage
        case selectMode
    }
}
