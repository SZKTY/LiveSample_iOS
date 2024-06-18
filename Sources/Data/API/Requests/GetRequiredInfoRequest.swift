//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/18.
//

import Foundation
import Alamofire

/// 必須項目登録情報取得API
public struct GetRequiredInfoRequest: GetRequest {
    public typealias Response = GetRequiredInfoResponse
    
    public var path: String {
        return "/users/required_info"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init() {}
}

public struct GetRequiredInfoResponse: Decodable, Equatable {
    public var accountName: String
    public var accountId: String
    public var accounType: String
    
    public init(accountName: String, accountId: String, accounType: String) {
        self.accountName = accountName
        self.accountId = accountId
        self.accounType = accounType
    }
}

extension GetRequiredInfoResponse {
    public static func stub() -> Self {
        .init(accountName: "", accountId: "", accounType: "")
    }
}
