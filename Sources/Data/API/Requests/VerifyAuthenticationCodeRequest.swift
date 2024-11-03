//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/03.
//

import Foundation
import Alamofire

/// メールアドレス認証実施
public struct VerifyAuthenticationCodeRequest: PostRequest {
    public typealias Response = VerifyAuthenticationCodeResponse
    
    public var path: String {
        return "/email/verification/execute"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(code: String) {
        self.parameters = [
            "verification_code": code
        ]
    }
}

public struct VerifyAuthenticationCodeResponse: Decodable {
}
