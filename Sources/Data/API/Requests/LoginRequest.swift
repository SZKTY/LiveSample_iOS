//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/19.
//

import Foundation
import Alamofire

/// アカウント発行
public struct LoginRequest: PostRequest {
    public typealias Response = LoginResponse
    
    public var path: String {
        return "/login/email"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(email: String, password: String) {
        self.parameters = [
            "email": email,
            "password": password
        ]
    }
}

public struct LoginResponse: Decodable {
    public var sessionId: String
}
