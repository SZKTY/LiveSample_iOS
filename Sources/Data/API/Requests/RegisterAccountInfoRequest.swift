//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// アカウント情報登録
public struct RegisterAccountInfoRequest: PostRequest {
    public typealias Response = RegisterAccountInfoResponse
    
    public var path: String {
        return "/users/account/info"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(accountId: String, accountName: String) {
        parameters = [
            "account_id": accountId,
            "account_name": accountName
        ]
    }
}

public struct RegisterAccountInfoResponse: Decodable {
}

