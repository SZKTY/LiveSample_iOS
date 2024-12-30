//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import Foundation
import Alamofire

/// パスワードリセット実施API
public struct ResetPasswordRequest: PostRequest {
    public typealias Response = ResetPasswordResponse
    
    public var path: String {
        return "/password/reset"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(passwordResetToken: String, password: String) {
        parameters = [
            "password_reset_token": passwordResetToken,
            "password": password
        ]
    }
}

public struct ResetPasswordResponse: Decodable {
}
