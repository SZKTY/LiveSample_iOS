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
import Map
import MapStore

public struct RootView: View {
    @EnvironmentObject var loginRouter: LoginRouter
    let store: StoreOf<Root>
    
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            switch self.loginRouter.isLogin {
                /// ログイン済み
            case true:
                MapView(
                    store: Store(
                        initialState: MapStore.State()) {
                            MapStore()
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
        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        .task {
            await store.send(.task).finish()
        }
    }
}
