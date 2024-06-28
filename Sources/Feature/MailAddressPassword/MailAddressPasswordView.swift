//
//  MailAddressPasswordView.swift
//
//
//  Created by toya.suzuki on 2024/03/24.
//

import SwiftUI
import ComposableArchitecture
import MailAddressPasswordStore
import Assets
import ViewComponents
import Routing

@MainActor
public struct MailAddressPasswordView: View {
    enum FocusStates {
        case mail, password
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var loginChecker: LoginChecker
    @EnvironmentObject var accountTypeChecker: AccountTypeChecker
    @FocusState private var focusState : FocusStates?
    
    @Dependency(\.viewBuildingClient.accountIdNameView) var accountIdNameView
    @Dependency(\.viewBuildingClient.selectModeView) var selectModeView
    
    private let store: StoreOf<MailAddressPassword>
    
    public nonisolated init(store: StoreOf<MailAddressPassword>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.mainSubColor
                    .edgesIgnoringSafeArea(.all)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                focusState = nil
                            }
                    )
                
                VStack(alignment: .leading, spacing: 36) {
                    Spacer()
                    
                    if !viewStore.isLogin {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("メールアドレスとパスワードを\n入力してください")
                                .font(.system(size: 20, weight: .heavy))
                                .frame(height: 48)
                            
                            Text("メールアドレスは会員登録のみに利用され、\n外部に公開されることは一切ございません。")
                                .font(.system(size: 16, weight: .light))
                                .underline()
                                .frame(height: 40)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        if viewStore.isLogin {
                            Text("メールアドレスを入力してください")
                                .font(.system(size: 17, weight: .light))
                        }
                        
                        TextField("Email", text: viewStore.$email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .focused($focusState, equals: .mail)
                            .modifier(TextFieldModifier())
                        
                        if viewStore.isLogin {
                            Text("パスワードを入力してください")
                                .font(.system(size: 17, weight: .light))
                        }
                        
                        PasswordTextField("Password", text: viewStore.$password)
                            .focused($focusState, equals: .password)
                            .modifier(TextFieldModifier())
                    }
                    
                    Button(action: {
                        viewStore.send(.nextButtonTapped)
                    }) {
                        Text(viewStore.isLogin ? "ログイン" : "次へ")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 20, weight: .heavy))
                            .bold()
                            .foregroundStyle(.white)
                            .background(viewStore.isEnableNextButton ? Color.mainBaseColor : Color.inactiveColor)
                            .cornerRadius(.infinity)
                    }
                    .disabled(!viewStore.isEnableNextButton)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle(viewStore.isLogin ? "ログイン" : "1 / 4")
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
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didFinishLogin)) { _ in
                loginChecker.isLogin = true
                accountTypeChecker.reload()
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
            .navigationDestination(
                store: store.scope(state: \.$destination.accountIdName,
                                   action: \.destination.accountIdName)
            ) { store in
                accountIdNameView(store)
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.selectMode,
                                   action: \.destination.selectMode)
            ) { store in
                selectModeView(store)
            }
        }
    }
}
