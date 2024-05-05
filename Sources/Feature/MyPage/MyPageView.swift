//
//  SwiftUIView.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import MyPageStore

public struct MyPageView: View {
    let store: StoreOf<MyPage>
    
    public nonisolated init(store: StoreOf<MyPage>) {
        self.store = store
    }
    
    public var body: some View {
        Text("MyPage")
    }
}
