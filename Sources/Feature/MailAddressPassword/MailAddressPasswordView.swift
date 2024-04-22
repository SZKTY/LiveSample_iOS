//
//  MailAddressPasswordView.swift
//
//
//  Created by toya.suzuki on 2024/03/24.
//

import SwiftUI
import ComposableArchitecture
import MailAddressPasswordStore
import Routing

@MainActor
public struct MailAddressPasswordView: View {
    @EnvironmentObject var router: NavigationRouter
    let store: StoreOf<MailAddressPassword>
    
    public nonisolated init(store: StoreOf<MailAddressPassword>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            WithPerceptionTracking {
                VStack(alignment: .leading, spacing: 32) {
                    Text("メールアドレスとパスワードを\n入力してください。")
                        .font(.system(size: 20, weight: .black))
                        .padding(.top, 80)
                    
                    TextField("メールアドレス", text: viewStore.$email)
                        .padding()
                        .padding(.leading, 15)
                        .font(.system(size: 27, weight: .medium))
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(5)
                    
                    TextField("パスワード", text: viewStore.$password)
                        .padding()
                        .padding(.leading, 15)
                        .font(.system(size: 27, weight: .medium))
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(5)
                    
                    Button(action: {
                        self.router.items.append(.accountId)
                    }) {
                        Text("次へ")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .accentColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(.infinity)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .background(
                    Image("mainBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}