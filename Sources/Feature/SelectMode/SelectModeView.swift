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
import PopupView
import Constants

@MainActor
public struct SelectModeView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var loginChecker: LoginChecker
    @EnvironmentObject var accountTypeChecker: AccountTypeChecker
    
    let store: StoreOf<SelectMode>
    
    public nonisolated init(store: StoreOf<SelectMode>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                        store.send(.startButtonTapped)
                    }) {
                        Text("SPREETをはじめる")
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
            .disabled(viewStore.isBusy)
            .padding(.horizontal, 20)
            .background(Color.mainSubColor)
            .navigationTitle("4 / 4")
            .navigationBarBackButtonHidden()
            .alert(store: store.scope(state: \.$alert, action: \.alert))
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didFinishRegisterAccountInfo)) { _ in
                loginChecker.isLogin = true
                accountTypeChecker.reload()
            }
            .popup(isPresented: viewStore.$isBusy) {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                        .tint(Color.white)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .scaleEffect(1.2)
                }
            }
        }
    }
}

struct TermsOfServiceAndPrivacyPolicyView: View {
    var body: some View {
        HStack(spacing: 0) {
            Link(destination: Constants.shared.termOfServiceUrl, label: {
                Text("利用規約")
                    .underline()
            })
            
            Text("および")
                .foregroundStyle(.black)
            
            Link(destination: Constants.shared.privacyPolicyUrl, label: {
                Text("プライバシーポリシー")
                    .underline()
            })
            
            Text("に同意して")
                .foregroundStyle(.black)
        }
        .font(.system(size: 12, weight: .light))
        
    }
}
