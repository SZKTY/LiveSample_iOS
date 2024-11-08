//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/14.
//

import Foundation
import MapKit

public class PostAnnotation: MKPointAnnotation {
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

extension PostAnnotation {
    public static func stub() -> PostAnnotation {
        .init(
            postId: 1,
            postUserId: 12345,
            postUserAccountName: "Test",
            postUserAccountId: "Test1234",
            postUserProfileImagePath: "",
            postImagePath: "",
            coordinateX: "37.78501364540698",
            coordinateY: "-122.40686186375606",
            freeText: "Test",
            startDatetime: "2024-10-19T02:05:25Z",
            endDatetime: "2024-10-20T04:10:25Z",
            createdAt: "2024-10-19T03:05:25Z"
        )
    }
}
