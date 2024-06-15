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
        List {
            Text("プロフィール編集")
                .onTapGesture {
                    // プロフィール編集遷移処理
                }
            
            Text("利用規約")
                .onTapGesture {
                    // 利用規約遷移処理
                }
            
            Text("プライバシーポリシー")
                .onTapGesture {
                    // プライバシーポリシー遷移処理
                }
            
            Text("アカウントの削除")
                .onTapGesture {
                    // メーラー？
                }
            
            Text("お問い合わせ")
                .onTapGesture {
                    // お問い合わせ遷移処理
                }
        }
    }
}
