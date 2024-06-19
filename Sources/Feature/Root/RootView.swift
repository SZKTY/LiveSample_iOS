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
import Map
import MapStore
import Assets
import Routing

public struct RootView: View {
    @EnvironmentObject var loginRouter: LoginRouter
    let store: StoreOf<Root>
    
    public init(store: StoreOf<Root>) {
        self.store = store
        store.send(.initialize)
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            // 初期化済みか
            switch viewStore.isInitialized {
            case true:
                // ログイン済みか
                switch self.loginRouter.isLogin {
                case true:
                    MapView(
                        store: Store(
                            initialState: MapStore.State()) {
                                MapStore()
                            }
                    )
                case false:
                    WelcomeView(
                        store: Store(
                            initialState: Welcome.State(requiredInfo: viewStore.requiredInfo)) {
                                Welcome()
                            }
                    )
                }
            case false:
                // TODO: - スプラッシュが決まった後、スプラッシュと合わせる
                ZStack {
                    Color.subSubColor
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        .task {
            await store.send(.task).finish()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.changeToLogout)) { _ in
            self.loginRouter.isLogin = true
        }
    }
}
