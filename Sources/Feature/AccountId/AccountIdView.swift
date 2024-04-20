//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import AccountIdStore
import Routing

@MainActor
public struct AccountIdView: View {
    @EnvironmentObject var router: NavigationRouter
    let store: StoreOf<AccountId>
    
    public nonisolated init(store: StoreOf<AccountId>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 30){
                Text("アカウントIDを入力してください。")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .black))
                    .padding(.top, 80)
                
                TextField("Your User ID", text: viewStore.$accountId)
                    .padding()
                    .padding(.leading, 15)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)
                
                Button(action: {
                    self.router.items.append(.accountName)
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

