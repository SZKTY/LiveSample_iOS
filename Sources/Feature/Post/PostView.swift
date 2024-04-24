//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import PostStore

public struct PostView: View {
    let store: StoreOf<Post>
    
    public init(store: StoreOf<Post>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Post")
    }
}
