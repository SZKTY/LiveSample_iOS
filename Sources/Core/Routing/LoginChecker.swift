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
        guard let sessionId = ud?.string(forKey: "SessionIdKey"),
              let userId = ud?.string(forKey: "UserIdKey") else { return }
        
        isLogin = !sessionId.isEmpty && !userId.isEmpty
    }
}
