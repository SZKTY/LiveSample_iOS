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
                        Spacer()
                        
                        Text("Live Sample")
                            .foregroundStyle(.white)
                            .font(.system(size: 30, weight: .heavy))
                        
                        Spacer()
                        
                        // サインアップボタン
                        LoginSignupButton(isLogin: false) {
                            viewStore.send(.signInButtonTapped)
                        }
                        
                        // 利用規約とプライバシーポリシー
                        TermsOfServiceAndPrivacyPolicyView()
                        
                        // ログインボタン
                        LoginSignupButton(isLogin: true) {
                            viewStore.send(.loginButtonTapped)
                        }
                        
                    }
                    .background(Color.subBaseColor)
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

struct TermsOfServiceAndPrivacyPolicyView: View {
    var body: some View {
        VStack {
            Text("本アプリでは「Get started」を押した時点で")
                .foregroundStyle(.white)
            
            HStack(spacing: 0) {
                if let url = URL(string: "https://www.apple.com/") {
                    Link("利用規約", destination: url)
                }
                
                Text("と")
                    .foregroundStyle(.white)
                
                if let url = URL(string: "https://www.apple.com/") {
                    Link("プライバシーポリシー", destination: url)
                }
                
                Text("に同意いただいたことになります。")
                    .foregroundStyle(.white)
            }
        }
        .font(.system(size: 12, weight: .medium))
        .padding(.horizontal, 5)
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
            Text(isLogin ? "ログイン" : "サインアップ")
                .font(.system(size: 20, weight: .heavy))
        })
        .frame(maxWidth: .infinity, minHeight: 70)
        .foregroundStyle(isLogin ? .white : .black)
        .background(isLogin ? Color.mainBaseColor : Color.subSubColor)
        .cornerRadius(.infinity)
        .padding(.horizontal, 30)
    }
}
