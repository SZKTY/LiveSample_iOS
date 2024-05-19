//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/20.
//

import Foundation

public class LoginRouter: ObservableObject {
    @Published public var isLogin: Bool = false
    
    public init() {
        self.isLogin = UserDefaults(suiteName: "group.inemuri")?.string(forKey: "SessionIdKey") != nil
    }
}
