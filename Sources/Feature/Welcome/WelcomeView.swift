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

@MainActor
public struct WelcomeView: View {
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
                    VStack(spacing: 20) {
                        ZStack {
                            Image(uiImage: UIImage(named: "welcome")!)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Rectangle())
                            
                            VStack {
                                Spacer ()
                                
                                Text("Live Sample")
                                    .foregroundStyle(Color.mainBaseColor)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 30, weight: .heavy))
                                
                                Spacer ()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        
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
                                print("check: Tapped")
                            } label: {
                                Text("お困りの方はこちら")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundStyle(Color.mainBaseColor)
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
                .background(Color.mainSubColor)
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
                .padding(.horizontal, 30)
        })
    }
}
