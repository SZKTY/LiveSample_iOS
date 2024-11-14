//
//  PasswordView.swift
//
//
//  Created by toya.suzuki on 2024/03/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import PasswordStore
import Assets
import ViewComponents
import Routing
import PopupView

@MainActor
public struct PasswordView: View {
    enum FocusStates {
        case password
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusState : FocusStates?
    @Dependency(\.viewBuildingClient.accountIdNameView) var accountIdNameView
    
    private let store: StoreOf<Password>
    
    public nonisolated init(store: StoreOf<Password>) {
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
                        Text("パスワードを入力してください")
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
            .navigationTitle("3 / 6")
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
            .navigationDestination(
                store: store.scope(state: \.$destination.accountIdName,
                                   action: \.destination.accountIdName)
            ) { store in
                accountIdNameView(store)
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
