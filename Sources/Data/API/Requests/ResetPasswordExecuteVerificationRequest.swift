//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import Foundation
import Alamofire

/// パスワードリセット認証実施API
public struct ResetPasswordExecuteVerificationRequest: PostRequest {
    public typealias Response = ResetPasswordExecuteVerificationResponse
    
    public var path: String {
        return "/password/reset/verification/execute"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(email: String, code: String) {
        parameters = [
            "email": email,
            "code": code
        ]
    }
}

public struct ResetPasswordExecuteVerificationResponse: Decodable {
    public var passwordResetToken: String
}
