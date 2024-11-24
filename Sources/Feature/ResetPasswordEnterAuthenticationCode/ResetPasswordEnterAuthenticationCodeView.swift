//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ResetPasswordEnterAuthenticationCodeStore
import Assets
import ViewComponents
import Routing
import PopupView

@MainActor
public struct ResetPasswordEnterAuthenticationCodeView: View {
    enum FocusStates {
        case code
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusState : FocusStates?
    
    private let store: StoreOf<ResetPasswordEnterAuthenticationCode>
    
    public nonisolated init(store: StoreOf<ResetPasswordEnterAuthenticationCode>) {
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
                        Text("\(viewStore.email)\nに届いた認証コードを\n入力してください")
                            .font(.system(size: 20, weight: .heavy))
                      
                        DisablePasteTextField(placeHolder: "Authentication code", text: viewStore.$code)
                            .frame(height: 32)
                            .focused($focusState, equals: .code)
                            .modifier(TextFieldModifier())
                            .onReceive(Just(viewStore.code)) { _ in
                                    viewStore.send(.didChangeAuthenticationCode)
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

