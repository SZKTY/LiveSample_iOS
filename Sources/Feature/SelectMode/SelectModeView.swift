//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import SelectModeStore
import Routing

@MainActor
public struct SelectModeView: View {
    @EnvironmentObject var loginRouter: LoginRouter
    let store: StoreOf<SelectMode>
    
    public nonisolated init(store: StoreOf<SelectMode>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                Text("アーティストですか")
                    .font(.system(size: 20, weight: .black))
                
                Spacer()
                
                Button(action: {
                    self.store.send(.didTapMusician)
                    self.loginRouter.isLogin = true
                }) {
                    Text("はい")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                }
                .accentColor(Color.white)
                .background(Color.black)
                .cornerRadius(.infinity)
                
                Button(action: {
                    print("check: userRegist AccountName = \(viewStore.userRegist.accountName)")
                    self.store.send(.didTapFan)
                }) {
                    Text("いいえ")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                }
                .accentColor(Color.white)
                .background(Color.black)
                .cornerRadius(.infinity)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 80)
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

