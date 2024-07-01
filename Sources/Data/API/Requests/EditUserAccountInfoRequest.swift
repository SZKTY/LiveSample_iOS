//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/28.
//

import Foundation
import Alamofire

/// ユーザーアカウント情報編集
public struct EditUserAccountInfoRequest: PutRequest {
    public typealias Response = EditUserAccountInfoResponse
    
    public var path: String {
        return "/users/account/info"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(accountId: String, accountName: String) {
        self.parameters = [
            "account_name": accountName,
            "account_id": accountId
        ]
    }
}

public struct EditUserAccountInfoResponse: Decodable {
}
