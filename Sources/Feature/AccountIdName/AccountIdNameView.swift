//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import Combine
import ComposableArchitecture
import AccountIdNameStore
import Assets
import ViewComponents
import Routing
import PopupView

@MainActor
public struct AccountIdNameView: View {
    enum FocusStates {
        case accountId, accountName
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusState : FocusStates?
    
    @Dependency(\.viewBuildingClient.profileImageView) var profileImageView
    
    private let store: StoreOf<AccountIdName>
    
    public nonisolated init(store: StoreOf<AccountIdName>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
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
                    
                    Text("アカウント名とアカウントIDを\n入力してください")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(height: 48)
                    
                    VStack(spacing: 8) {
                        DisablePasteTextField(
                            placeHolder: "Your Name",
                            text: viewStore.$accountName,
                            validJapanese: false
                        )
                        .frame(height: 32)
                        .focused($focusState, equals: .accountName)
                        .modifier(TextFieldModifier())
                        .onReceive(Just(viewStore.accountName)) { _ in
                            viewStore.send(.didChangeAccountName)
                        }
                        
                        HStack() {
                            Spacer()
                            
                            Button {
                                viewStore.send(.whatIsAccountNameButtonTapped)
                            } label: {
                                
                                HStack {
                                    Text("アカウント名について")
                                        .font(.system(size: 14, weight: .light))
                                    
                                    Text("?")
                                        .font(.system(size: 12))
                                        .bold()
                                        .frame(width: 16, height: 16)
                                        .background(.black)
                                        .foregroundStyle(.white)
                                        .cornerRadius(4)
                                }
                            }
                        }
                        
                    }
                    
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("@")
                                .font(.system(size: 20))
                                .frame(height: 48)
                            
                            DisablePasteTextField(placeHolder: "Account ID", text: viewStore.$accountId)
                                .frame(height: 32)
                                .focused($focusState, equals: .accountId)
                                .modifier(TextFieldModifier())
                                .onReceive(Just(viewStore.accountId)) { _ in
                                    viewStore.send(.didChangeAccountId)
                                }
                        }
                        
                        
                        HStack() {
                            Spacer()
                            
                            Button {
                                viewStore.send(.whatIsAccountIdButtonTapped)
                            } label: {
                                HStack {
                                    Text("アカウントIDについて")
                                        .font(.system(size: 14, weight: .light))
                                    
                                    Text("?")
                                        .font(.system(size: 12))
                                        .bold()
                                        .frame(width: 16, height: 16)
                                        .background(.black)
                                        .foregroundStyle(.white)
                                        .cornerRadius(4)
                                }
                                
                            }
                        }
                    }
                    
                    Button(action: {
                        viewStore.send(.nextButtonTapped)
                    }) {
                        Text("次へ")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 20, weight: .medium))
                            .bold()
                            .foregroundStyle(.white)
                            .background(viewStore.isEnableNextButton ? Color.mainBaseColor : Color.inactiveColor)
                            .cornerRadius(.infinity)
                    }
                    .disabled(!viewStore.isEnableNextButton)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 80)
                
            }
            .disabled(viewStore.isBusy)
            .navigationTitle("2 / 4")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .navigationDestination(
                store: self.store.scope(state: \.$destination.profileImage,
                                        action: \.destination.profileImage)
            ) { store in
                self.profileImageView(store)
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

