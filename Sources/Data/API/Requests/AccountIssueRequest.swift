//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// アカウント発行
struct AccountIssueRequest: PutRequest {
    typealias Response = AccountIssueResponse
    
    var path: String {
        return ""
    }
    
    var headers: HTTPHeaders?
    var parameters: Parameters?
    
    init(email: String) {
        parameters = [
            "email": email
        ]
    }
}

struct AccountIssueResponse: Decodable {
    
}
