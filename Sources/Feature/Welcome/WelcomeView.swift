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
import AccountIdStore
import AccountNameStore
import MailAddressPasswordStore
import ProfileImageStore
import SelectModeStore

@MainActor
public struct WelcomeView: View {
    @Dependency(\.viewBuildingClient.accountIdView) var accountIdView
    @Dependency(\.viewBuildingClient.accountNameView) var accountNameView
    @Dependency(\.viewBuildingClient.mailAddressPasswordView) var mailAddressPasswordView
    @Dependency(\.viewBuildingClient.profileImageView) var profileImageView
    @Dependency(\.viewBuildingClient.selectModeView) var selectModeView
    @Dependency(\.viewBuildingClient.welcomeView) var welcomeView
    
    @EnvironmentObject var router: NavigationRouter
    let store: StoreOf<Welcome>
    
    public nonisolated init(store: StoreOf<Welcome>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: self.$router.items) {
            VStack(spacing: 20) {
                Spacer()
                Text("Live Sample")
                    .font(.system(size: 30, weight: .heavy))
                
                Spacer()
                
                Button(action: {
                    self.router.items.append(.mailAddressPassword)
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
                    self.router.items.append(.accountId)
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
            .navigationDestination(for: NavigationRouter.WelcomePath.self) { item in
                switch item {
                case .accountId:
                    accountIdView(
                        Store(
                            initialState: AccountId.State()) {
                                AccountId()
                            }
                    )
                case .welcome:
                    welcomeView(
                        Store(
                            initialState: Welcome.State()) {
                                Welcome()
                            }
                    )
                case .mailAddressPassword:
                    mailAddressPasswordView(
                        Store(
                            initialState: MailAddressPassword.State()) {
                                MailAddressPassword()
                            }
                    )
                case .accountName:
                    accountNameView(
                        Store(
                            initialState: AccountName.State()) {
                                AccountName()
                            }
                    )
                case .profileImage:
                    profileImageView(
                        Store(
                            initialState: ProfileImage.State()) {
                                ProfileImage()
                            }
                    )
                case .selectMode:
                    selectModeView(
                        Store(
                            initialState: SelectMode.State()) {
                                SelectMode()
                            }
                    )
                }
            }
        }
    }
}
