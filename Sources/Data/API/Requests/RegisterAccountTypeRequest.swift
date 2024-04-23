//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// プロフィール写真登録
public struct RegisterAccountTypeRequest: PutRequest {
    public typealias Response = RegisterAccountTypeResponse
    
    public var path: String {
        return ""
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(isMusician: Bool) {
        parameters = [
            "isMusician": isMusician
        ]
    }
}

public struct RegisterAccountTypeResponse: Decodable {
    
}
