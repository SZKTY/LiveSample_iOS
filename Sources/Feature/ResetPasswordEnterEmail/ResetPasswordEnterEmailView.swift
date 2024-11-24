//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ResetPasswordEnterEmailStore
import Assets
import ViewComponents
import Routing
import PopupView

@MainActor
public struct ResetPasswordEnterEmailView: View {
    enum FocusStates {
        case email
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusState : FocusStates?
    @Dependency(\.viewBuildingClient.resetPasswordEnterAuthenticationCodeView) var resetPasswordEnterAuthenticationCodeView
    
    private let store: StoreOf<ResetPasswordEnterEmail>
    
    public nonisolated init(store: StoreOf<ResetPasswordEnterEmail>) {
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
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("登録済みのメールアドレスを\n入力してください")
                            .font(.system(size: 20, weight: .heavy))
                      
                        DisablePasteTextField(placeHolder: "Email", text: viewStore.$email)
                            .frame(height: 32)
                            .focused($focusState, equals: .email)
                            .modifier(TextFieldModifier())
                            .onReceive(Just(viewStore.email)) { _ in
                                    viewStore.send(.didChangeEmail)
                            }
                    }
                    
                    Button(action: {
                        viewStore.send(.nextButtonTapped)
                    }) {
                        Text("次へ")
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
            .disabled(viewStore.isBusy)
            .navigationTitle("パスワードリセット")
            .navigationBarTitleDisplayMode(.inline)
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
            .navigationDestination(
                store: store.scope(state: \.$destination.resetPasswordEnterAuthenticationCode,
                                   action: \.destination.resetPasswordEnterAuthenticationCode)
            ) { store in
                resetPasswordEnterAuthenticationCodeView(store)
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
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

