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
    @EnvironmentObject var loginChecker: LoginChecker
    let store: StoreOf<Root>
    
    public init(store: StoreOf<Root>) {
        self.store = store
        store.send(.task)
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            // 初期化済みか
            switch viewStore.isInitialized {
            case true:
                // ログイン済みか
                switch loginChecker.isLogin {
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
                            initialState: Welcome.State(
                                requiredInfo: viewStore.requiredInfo
                            )
                        ) {
                            Welcome()
                        }
                    )
                }
            case false:
                ZStack {
                    Color.mainSubColor
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .alert(store: store.scope(state: \.$alert, action: \.alert))
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.changeToLogout)) { _ in
            if loginChecker.isLogin {
                loginChecker.isLogin = false
            }
        }
    }
}
