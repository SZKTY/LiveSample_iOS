//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// アカウント情報登録
struct AccountInfoRegistRequest: PutRequest {
    typealias Response = AccountInfoRegistResponse
    
    var path: String {
        return ""
    }
    
    var headers: HTTPHeaders?
    var parameters: Parameters?
    
    init(accountId: String, accountName: String) {
        parameters = [
            "account_id": accountId,
            "account_name": accountName
        ]
    }
}

struct AccountInfoRegistResponse: Decodable {
    
}

