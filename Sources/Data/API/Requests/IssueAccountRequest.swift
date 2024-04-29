//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// アカウント発行
public struct IssueAccountRequest: PutRequest {
    public typealias Response = IssueAccountResponse
    
    public var path: String {
        return ""
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(email: String, password: String) {
        parameters = [
            "email": email,
            "password": password
        ]
    }
}

public struct IssueAccountResponse: Decodable {
    
}
