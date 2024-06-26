//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/26.
//

import Foundation
import Alamofire

/// 投稿一覧取得
public struct GetPostsRequest: GetRequest {
    public typealias Response = GetPostsResponse
    
    public var path: String {
        return "/posts"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init() {
    }
}

public struct GetPostsResponse: Decodable {
    public var posts: [GetPostEntity]?
}

public struct GetPostEntity: Equatable, Decodable {
    public var postId: Int
    public var postUserId: Int
    public var postUserAccountName: String
    public var postUserAccountId: String
    public var postUserProfileImagePath: String
    public var postImagePath: String
    public var coordinateX: String
    public var coordinateY: String
    public var freeText: String
    public var startDatetime: String
    public var endDatetime: String
    public var createdAt: String
    
    public init(
        postId: Int,
        postUserId: Int,
        postUserAccountName: String,
        postUserAccountId: String,
        postUserProfileImagePath: String,
        postImagePath: String,
        coordinateX: String,
        coordinateY: String,
        freeText: String,
        startDatetime: String,
        endDatetime: String,
        createdAt: String
    ) {
        self.postId = postId
        self.postUserId = postUserId
        self.postUserAccountName = postUserAccountName
        self.postUserAccountId = postUserAccountId
        self.postUserProfileImagePath = postUserProfileImagePath
        self.postImagePath = postImagePath
        self.coordinateX = coordinateX
        self.coordinateY = coordinateY
        self.freeText = freeText
        self.startDatetime = startDatetime
        self.endDatetime = endDatetime
        self.createdAt = createdAt
    }
}
