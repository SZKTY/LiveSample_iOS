//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/20.
//

import Foundation

public class LoginChecker: ObservableObject {
    @Published public var isLogin: Bool = false
    private let ud = UserDefaults(suiteName: "group.inemuri")
    
    public init() {
        self.isLogin = ud?.string(forKey: "SessionIdKey") != nil && ud?.string(forKey: "UserIdKey") != nil
    }
}
