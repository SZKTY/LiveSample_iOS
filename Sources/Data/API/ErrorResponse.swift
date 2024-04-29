//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation

enum PreRequestError: Error {
    case tokenNotFound
    case unknownError
}

enum ResponseError: Error {
    case unexpectedResponse
}

class ErrorResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case error
    }
    private enum ErrorCodingKeys: String, CodingKey {
        case message
    }

    let message: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorContainer = try container.nestedContainer(keyedBy: ErrorCodingKeys.self, forKey: .error)
        self.message = try errorContainer.decode(String.self, forKey: .message)
    }

    static func decode(_ data: Data) throws -> ErrorResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ErrorResponse.self, from: data)
    }
}

