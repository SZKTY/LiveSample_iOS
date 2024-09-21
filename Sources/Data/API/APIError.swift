//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation

public protocol MessageRepresentableError: Error {
    var message: String { get }
}

public enum APIError: MessageRepresentableError {
    case badRequest(errors: ErrorResponse?)
    case unauthorized(errors: ErrorResponse?)
    case forbidden(errors: ErrorResponse?)
    case notFound(errors: ErrorResponse?)
    case internalServerError(errors: ErrorResponse?)
    case serviceUnavailable
    case parseError
    case unknown

    public var message: String {
        switch self {
        case .badRequest(let errors):
            return errors?.message ?? "リクエストに失敗しました。"
        case .unauthorized(let errors):
            return errors?.message ?? "認証に失敗しました。"
        case .forbidden(let errors):
            return errors?.message ?? "許可されていないアクセスです。"
        case .notFound(let errors):
            return errors?.message ?? "リソースが見つかりませんでした。"
        case .internalServerError(let errors):
            return errors?.message ?? "サーバエラーが発生しました。"
        case .serviceUnavailable:
            return "サーバがリクエストを処理できませんでした。"
        case .parseError:
            return "予期せぬレスポンスを受信しました。"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
    
    public init?(statusCode: Int?, data: Data?) {
        switch (statusCode, data) {
        case (400?, let data?):
            do {
                let errors = try ErrorResponse.decode(data)
                self = .badRequest(errors: errors)
            } catch {
                self = .badRequest(errors: nil)
            }
        case (400?, .none):
            self = .badRequest(errors: nil)
        case (401?, let data?):
            let errors = try? ErrorResponse.decode(data)
            self = .unauthorized(errors: errors)
        case (403?, let data?):
            do {
                let errors = try ErrorResponse.decode(data)
                self = .forbidden(errors: errors)
            } catch {
                self = .forbidden(errors: nil)
            }
        case (403?, .none):
            self = .forbidden(errors: nil)
        case (404?, let data?):
            do {
                let errors = try ErrorResponse.decode(data)
                self = .notFound(errors: errors)
            } catch {
                self = .notFound(errors: nil)
            }
        case (404?, .none):
            self = .notFound(errors: nil)
        case (500?, let data?):
            let errors = try? ErrorResponse.decode(data)
            self = .internalServerError(errors: errors)
        case (503?, _):
            self = .serviceUnavailable
        default:
            return nil
        }
    }
}

extension Error {
    public var asApiError: APIError? {
        return self as? APIError
    }

    public var asMessageRepresentableError: MessageRepresentableError? {
        return self as? MessageRepresentableError
    }
}

