//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// プロフィール写真登録
public struct RegisterProfilePictureRequest: PutRequest {
    public typealias Response = RegisterProfilePictureResponse
    
    public var path: String {
        return ""
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(data: Data) {
        parameters = [
            "data": data
        ]
    }
}

public struct RegisterProfilePictureResponse: Decodable {
    
}
