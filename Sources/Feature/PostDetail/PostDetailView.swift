//
//  SwiftUIView.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import SwiftUI
import ComposableArchitecture
import PostDetailStore

public struct PostDetailView: View {
    let store: StoreOf<PostDetail>
    
    public nonisolated init(store: StoreOf<PostDetail>) {
        self.store = store
        
        self.store.send(.initialize)
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text(viewStore.annotation.freeText)
            }
        }
    }
}
