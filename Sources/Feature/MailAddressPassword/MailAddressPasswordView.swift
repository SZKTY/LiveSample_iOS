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
    @EnvironmentObject var loginRouter: LoginRouter
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
                Color.subSubColor
                    .edgesIgnoringSafeArea(.all)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                focusState = nil
                            }
                    )
                
                VStack(alignment: .leading, spacing: 36) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("メールアドレスとパスワードを\n入力してください")
                            .font(.system(size: 20, weight: .black))
                            .frame(height: 48)
                        
                        Text("メールアドレスは会員登録のみに利用され、\n外部に公開されることは一切ございません。")
                            .font(.system(size: 16))
                            .frame(height: 40)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Email", text: viewStore.$email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .focused($focusState, equals: .mail)
                            .modifier(TextFieldModifier())
                        
                        
                        PasswordTextField("Password", text: viewStore.$password)
                            .focused($focusState, equals: .password)
                            .modifier(TextFieldModifier())
                    }
                    
                    Button(action: {
                        viewStore.send(.nextButtonTapped)
                    }) {
                        Text(viewStore.isLogin ? "ログイン" : "次へ")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 20, weight: .medium))
                            .bold()
                            .foregroundStyle(viewStore.isEnableNextButton ? .white : .white.opacity(0.3))
                            .background(viewStore.isEnableNextButton ? Color.mainBaseColor : .gray.opacity(0.5))
                            .cornerRadius(.infinity)
                    }
                    .disabled(!viewStore.isEnableNextButton)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("1 / 4")
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
                loginRouter.isLogin = true
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
