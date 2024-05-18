//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// アカウント発行
public struct IssueAccountRequest: PostRequest {
    public typealias Response = IssueAccountResponse
    
    public var path: String {
        return "/users/account"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(email: String, password: String) {
        self.headers = [
            "Content-Type": "application/json"
        ]
        
        self.parameters = [
            "email": email,
            "password": password
        ]
    }
}

public struct IssueAccountResponse: Decodable {
    public var userId: Int
    public var sessionId: String
}
