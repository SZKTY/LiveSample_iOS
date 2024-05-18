//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// ユーザーアカウント種別登録
public struct RegisterAccountTypeRequest: PostRequest {
    public typealias Response = RegisterAccountTypeResponse
    
    public var path: String {
        return "/users/account/type"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(accountType: String) {
        parameters = [
            "account_type": accountType
        ]
    }
}

public struct RegisterAccountTypeResponse: Decodable {
}
