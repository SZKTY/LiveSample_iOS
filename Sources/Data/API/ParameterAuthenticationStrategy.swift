//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation

class ParameterAuthenticationStrategy: AuthenticateStrategy {
    func addAuthInfo<T: APIRequest>(to request: T, token: String?) -> T {
        var origin = request
        if origin.parameters == nil {
            origin.parameters = [:]
        }
        if let token = token {
            origin.parameters!["token"] = token
        }
        return origin
    }
}
