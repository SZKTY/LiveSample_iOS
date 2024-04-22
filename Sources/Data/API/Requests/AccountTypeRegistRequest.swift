//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// プロフィール写真登録
struct AccountTypeRegistRequest: PutRequest {
    typealias Response = AccountTypeRegistResponse
    
    var path: String {
        return ""
    }
    
    var headers: HTTPHeaders?
    var parameters: Parameters?
    
    init(isMusician: Bool) {
        parameters = [
            "isMusician": isMusician
        ]
    }
}

struct AccountTypeRegistResponse: Decodable {
    
}
