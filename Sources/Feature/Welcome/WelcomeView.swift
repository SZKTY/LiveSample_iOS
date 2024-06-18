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
import WelcomeStore

@MainActor
public struct WelcomeView: View {
    @Dependency(\.viewBuildingClient.mailAddressPasswordView) var mailAddressPasswordView
    @Dependency(\.viewBuildingClient.accountIdNameView) var accountIdNameView
    @Dependency(\.viewBuildingClient.selectModeView) var selectModeView
    
    let store: StoreOf<Welcome>
    
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
                            .font(.system(size: 30, weight: .heavy))
                        
                        Spacer()
                        
                        Button(action: {
                            viewStore.send(.signInButtonTapped)
                        }, label: {
                            Text("Get started")
                                .font(.system(size: 20, weight: .heavy))
                        })
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(.infinity)
                        .padding(.horizontal, 30)
                        
                        VStack {
                            Text("本アプリでは「Get started」を押した時点で")
                            HStack(spacing: 0) {
                                if let url = URL(string: "https://www.apple.com/") {
                                    Link("利用規約", destination: url)
                                }
                                Text("と")
                                if let url = URL(string: "https://www.apple.com/") {
                                    Link("プライバシーポリシー", destination: url)
                                }
                                Text("に同意いただいたことになります。")
                            }
                        }
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 5)
                        
                        Button(action: {
                            viewStore.send(.loginButtonTapped)
                        }, label: {
                            Text("ログイン")
                                .font(.system(size: 20, weight: .heavy))
                        })
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(.infinity)
                        .padding(.horizontal, 30)
                        
                    }
                    .background(
                        Image("mainBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                    )
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
