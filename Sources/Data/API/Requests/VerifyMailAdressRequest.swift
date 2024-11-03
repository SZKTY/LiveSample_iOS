//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/03.
//

import Foundation
import Alamofire

/// メールアドレス認証開始
public struct VerifyMailAdressRequest: PostRequest {
    public typealias Response = VerifyMailAdressResponse
    
    public var path: String {
        return "/email/verification/start"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(email: String) {
        self.parameters = [
            "email": email
        ]
    }
}

public struct VerifyMailAdressResponse: Decodable {
}
