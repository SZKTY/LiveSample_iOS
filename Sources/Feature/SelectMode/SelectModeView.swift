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
                
                TermsOfServiceAndPrivacyPolicyView()
                
                Toggle(isOn: viewStore.$isAgree) {
                    Text("はい")
                        .font(.system(size: 24))
                        .bold()
                    
                }
                .toggleStyle(.checkBox)
                .padding(.leading, 20)
                
                Spacer()
                    .frame(height: 60)
                
                Button(action: {
                    store.send(.startButtonTapped)
                }) {
                    Text("SPREETをはじめる")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                        .bold()
                        .foregroundStyle(.white)
                        .background(viewStore.isAgree ? Color.mainBaseColor : Color.inactiveColor)
                        .cornerRadius(.infinity)
                }
                .disabled(!viewStore.isAgree)
                
                Spacer()
            }
            .disabled(viewStore.isBusy)
            .padding(.horizontal, 20)
            .background(Color.mainSubColor)
            .navigationTitle("4 / 4")
            .navigationBarTitleDisplayMode(.inline)
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
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Link(destination: Constants.shared.termOfServiceUrl, label: {
                    Text("利用規約")
                        .underline()
                })
                Text("および")
                    .foregroundStyle(.black)
            }
            
            HStack {
                Link(destination: Constants.shared.privacyPolicyUrl, label: {
                    Text("プライバシーポリシー")
                        .underline()
                })
                Text("に同意する")
                    .foregroundStyle(.black)
            }
        }
        .font(.system(size: 20, weight: .heavy))
    }
}
