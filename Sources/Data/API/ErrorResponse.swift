//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation

public enum PreRequestError: Error {
    case tokenNotFound
    case unknownError
}

public enum ResponseError: Error {
    case unexpectedResponse
}

public class ErrorResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case message
    }

    public let message: String

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
    }

    static func decode(_ data: Data) throws -> ErrorResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ErrorResponse.self, from: data)
    }
}

