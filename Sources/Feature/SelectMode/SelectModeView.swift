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
    @EnvironmentObject var loginChecker: LoginChecker
    
    let store: StoreOf<SelectMode>
    
    public nonisolated init(store: StoreOf<SelectMode>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 36) {
                Spacer()
                
                Text("あなたはアーティストですか？")
                    .font(.system(size: 20, weight: .heavy))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("活動状況によってご利用いただける機能が\n異なりますので、正しく選択してください。")
                        .font(.system(size: 16, weight: .light))
                        .underline()
                    
                    Text("アーティスト様が本人かどうかの確認をさせていただく場合があります。")
                        .font(.system(size: 12, weight: .light))
                        .underline()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle(isOn: viewStore.$isCheckedYes) {
                        Text("はい")
                            .font(.system(size: 24))
                            .bold()
                            
                    }
                    .toggleStyle(.checkBox)
                    
                    Toggle(isOn: viewStore.$isCheckedNo) {
                        Text("いいえ")
                            .font(.system(size: 24))
                            .bold()
                    }
                    .toggleStyle(.checkBox)
                }
                .padding(.leading, 20)
                
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 8) {
                    Toggle(isOn: viewStore.$isAgree) {
                        TermsOfServiceAndPrivacyPolicyView()
                    }
                    .toggleStyle(.checkBox)
                    
                    Button(action: {
                        self.store.send(.startButtonTapped)
                    }) {
                        Text("〇〇をはじめる")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 20, weight: .medium))
                            .bold()
                            .foregroundStyle(.white)
                            .background(viewStore.isEnableStartButton ? Color.mainBaseColor : Color.inactiveColor)
                            .cornerRadius(.infinity)
                    }
                    .disabled(!viewStore.isEnableStartButton)
                }
                
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .background(Color.mainSubColor)
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
                self.loginChecker.isLogin = true
            }
        }
    }
}

// TODO: 下線が出てない
struct TermsOfServiceAndPrivacyPolicyView: View {
    var body: some View {
        HStack(spacing: 0) {
            if let url = URL(string: "https://www.apple.com/") {
                Link(destination: url, label: {
                    Text("利用規約")
                        .underline()
                })
            }
            
            Text("および")
                .foregroundStyle(.black)
            
            if let url = URL(string: "https://www.apple.com/") {
                Link(destination: url, label: {
                    Text("プライバシーポリシー")
                        .underline()
                })
            }
            
            Text("に同意して")
                .foregroundStyle(.black)
        }
        .font(.system(size: 12, weight: .light))
        
    }
}
