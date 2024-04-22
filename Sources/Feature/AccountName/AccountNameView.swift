//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import AccountNameStore
import Routing

@MainActor
public struct AccountNameView: View {
    @Dependency(\.viewBuildingClient.profileImageView) var profileImageView
    private let store: StoreOf<AccountName>
    
    public nonisolated init(store: StoreOf<AccountName>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 30){
                Text("名前を入力してください。")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .black))
                    .padding(.top, 80)
                
                TextField("Your name", text: viewStore.$name)
                    .padding()
                    .padding(.leading, 15)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)
                
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
            .navigationDestination(
                store: store.scope(state: \.$destination.profileImage,
                                   action: \.destination.profileImage)
            ) { store in
                self.profileImageView(store)
            }
        }
    }
}
