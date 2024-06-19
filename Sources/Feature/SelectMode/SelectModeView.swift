//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import SelectModeStore
import ViewComponents
import Routing
import Assets

@MainActor
public struct SelectModeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var loginRouter: LoginRouter
    
    let store: StoreOf<SelectMode>
    
    public nonisolated init(store: StoreOf<SelectMode>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 36) {
                Spacer()
                
                Text("あなたはアーティストですか？")
                    .font(.system(size: 20, weight: .black))
                    .bold()
                
                Text("アーティストとファンで異なる機能を提供しています。\n正しくご選択いただきますようお願いいたします。\n（ご本人審査を行わせていただく場合があります。）")
                    .font(.system(size: 14))
                
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(isOn: viewStore.$isCheckedYes) {
                        Text("はい")
                            .bold()
                    }
                    .toggleStyle(.checkBox)
                    
                    Toggle(isOn: viewStore.$isCheckedNo) {
                        Text("いいえ")
                            .bold()
                    }
                    .toggleStyle(.checkBox)
                }
                .padding(.leading, 20)
                
                Spacer()
                    .frame(height: 60)
                
                Button(action: {
                    self.store.send(.didTapStartButton)
                }) {
                    Text("始める")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                        .bold()
                        .foregroundStyle(viewStore.isEnableStartButton ? .white : .white.opacity(0.3))
                        .background(viewStore.isEnableStartButton ? Color.mainBaseColor : .gray.opacity(0.5))
                        .cornerRadius(.infinity)
                }
                .disabled(!viewStore.isEnableStartButton)
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .background(Color.subSubColor)
            .navigationTitle("4 / 4")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 17, weight: .medium))
                        }
                    ).tint(.black)
                }
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didFinishRegisterAccountInfo)) { _ in
                self.loginRouter.isLogin = true
            }
        }
    }
}

