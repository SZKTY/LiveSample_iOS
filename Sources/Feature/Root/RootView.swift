//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import SwiftUI
import ComposableArchitecture
import RootStore
import Welcome
import WelcomeStore
import Routing
import Home
import HomeStore

public struct RootView: View {
    @EnvironmentObject var loginRouter: LoginRouter
    let store: StoreOf<Root>
    
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    public var body: some View {
        switch self.loginRouter.isLogin {
            /// ログイン済み
        case true:
            HomeView(
                store: Store(
                    initialState: Home.State()) {
                        Home()
                    }
            )
            /// 未ログイン
        case false:
            WelcomeView(
                store: Store(
                    initialState: Welcome.State()) {
                        Welcome()
                    }
            )
        }
    }
}
