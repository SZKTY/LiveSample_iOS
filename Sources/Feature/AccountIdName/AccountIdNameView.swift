//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import AccountIdNameStore
import Routing

@MainActor
public struct AccountIdNameView: View {
    @Dependency(\.viewBuildingClient.profileImageView) var profileImageView
    let store: StoreOf<AccountIdName>
    
    public nonisolated init(store: StoreOf<AccountIdName>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 30){
                Text("アカウントIDを入力してください。")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .black))
                
                TextField("Your Account ID", text: viewStore.$accountId)
                    .padding()
                    .padding(.leading, 15)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)
                
                Text("アカウント名を入力してください。")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .black))
                    .padding(.top, 20)
                
                TextField("Your Account Name", text: viewStore.$accountName)
                    .padding()
                    .padding(.leading, 15)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)
                
                Spacer()
                
                Button(action: {
                    viewStore.send(.nextButtonTapped)
                }) {
                    Text("次へ")
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
            .navigationDestination(
                store: self.store.scope(state: \.$destination.profileImage,
                                        action: \.destination.profileImage)
            ) { store in
                self.profileImageView(store)
            }
        }
    }
}

