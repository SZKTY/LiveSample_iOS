//
//  MailAddressView.swift
//
//
//  Created by toya.suzuki on 2024/03/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import MailAddressStore
import Assets
import ViewComponents
import Routing
import PopupView

@MainActor
public struct MailAddressView: View {
    enum FocusStates {
        case mail
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusState : FocusStates?
    @Dependency(\.viewBuildingClient.authenticationCodeView) var authenticationCodeView
    
    private let store: StoreOf<MailAddress>
    
    public nonisolated init(store: StoreOf<MailAddress>) {
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
                        Text("メールアドレスを入力してください")
                            .font(.system(size: 20, weight: .heavy))
                            .frame(height: 48)
                        
                        Text("メールアドレスは会員登録のみに利用され、\n外部に公開されることは一切ございません。")
                            .font(.system(size: 16, weight: .light))
                            .underline()
                            .frame(height: 40)
                        
                        DisablePasteTextField(placeHolder: "Email", text: viewStore.$email)
                            .frame(height: 32)
                            .focused($focusState, equals: .mail)
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
            .navigationTitle("1 / 6")
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
                store: store.scope(state: \.$destination.authenticationCode,
                                   action: \.destination.authenticationCode)
            ) { store in
                authenticationCodeView(store)
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
