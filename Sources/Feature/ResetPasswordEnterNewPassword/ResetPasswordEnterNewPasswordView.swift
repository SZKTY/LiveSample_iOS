//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ResetPasswordEnterNewPasswordStore
import Assets
import ViewComponents
import PopupView

@MainActor
public struct ResetPasswordEnterNewPasswordView: View {
    enum FocusStates {
        case password
    }
    
    @FocusState private var focusState : FocusStates?
    @Environment(\.dismiss) var dismiss
    
    private let store: StoreOf<ResetPasswordEnterNewPassword>
    
    public nonisolated init(store: StoreOf<ResetPasswordEnterNewPassword>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
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
                            Text("新しく設定したいパスワードを\n入力してください")
                                .font(.system(size: 20, weight: .heavy))
                                .frame(height: 48)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                PasswordTextField("Password", text: viewStore.$password)
                                    .frame(height: 32)
                                    .focused($focusState, equals: .password)
                                    .modifier(TextFieldModifier())
                                    .onReceive(Just(viewStore.password)) { _ in
                                            viewStore.send(.didChangePassword)
                                    }
                                
                                Text("大文字小文字アルファベット・数字を含む8文字以上")
                                    .font(.system(size: 12, weight: .light))
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
                                viewStore.send(.closeButtonTapped)
                            }, label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "xmark")
                                    Text("Cancel")
                                }
                                .font(.system(size: 15, weight: .regular))
                                .tint(.black)
                            }
                        )
                    }
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
}
