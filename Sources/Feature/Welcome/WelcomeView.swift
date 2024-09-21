//
//  WelcomeView.swift
//
//
//  Created by toya.suzuki on 2024/03/20.
//

import ComposableArchitecture
import Dependencies
import SwiftUI
import Routing
import Assets
import WelcomeStore
import Constants

@MainActor
public struct WelcomeView: View {
    @Environment(\.openURL) var openURL
    
    @Dependency(\.viewBuildingClient.mailAddressPasswordView) var mailAddressPasswordView
    @Dependency(\.viewBuildingClient.accountIdNameView) var accountIdNameView
    @Dependency(\.viewBuildingClient.selectModeView) var selectModeView
    
    private let store: StoreOf<Welcome>
    
    public nonisolated init(store: StoreOf<Welcome>) {
        self.store = store
        self.store.send(.initialize)
    }
    
    public var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                NavigationView {
                    ZStack(alignment: .bottom) {
                        ZStack {
                            Image(uiImage: UIImage(named: "welcome")!)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Rectangle())
                            
                            Image(uiImage: UIImage(named: "transparentIcon")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 300)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                        VStack(spacing: 20) {
                            // サインアップボタン
                            LoginSignupButton(isLogin: false) {
                                viewStore.send(.signInButtonTapped)
                            }
                            
                            // ログインボタン
                            LoginSignupButton(isLogin: true) {
                                viewStore.send(.loginButtonTapped)
                            }
                            
                            Button {
                                if let url = Constants.shared.artistRegisterFormUrl {
                                    openURL(url)
                                }
                            } label: {
                                Text("アーティスト登録の方はこちら")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundStyle(Color.mainBaseColor)
                            }
                            
                            Button {
                                if let url = Constants.shared.heplUrl {
                                    openURL(url)
                                }
                            } label: {
                                Text("お困りの方はこちら")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundStyle(Color.mainBaseColor)
                            }
                        }
                        .padding(36)
                        .background(Color.mainSubColor)
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.mailAddressPassword,
                                   action: \.destination.mailAddressPassword)
            ) { store in
                mailAddressPasswordView(store)
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.accountIdName,
                                   action: \.destination.accountIdName)
            ) { store in
                accountIdNameView(store)
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.selectMode,
                                   action: \.destination.selectMode)
            ) { store in
                selectModeView(store)
            }
        }
    }
}

struct LoginSignupButton: View {
    private let isLogin: Bool
    private let action: () -> Void
    
    init(isLogin: Bool, action: @escaping () -> Void) {
        self.isLogin = isLogin
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(isLogin ? "ログイン" : "会員登録")
                .font(.system(size: 20, weight: .heavy))
                .bold()
                .frame(maxWidth: .infinity, minHeight: 60)
                .foregroundStyle(isLogin ? .black : .white)
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(isLogin ? Color.mainSubColor : Color.mainBaseColor)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                )
        })
    }
}
