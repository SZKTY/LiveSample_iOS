//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import AccountIdNameStore
import Assets
import ViewComponents
import Routing

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
                        TextField("Your Name", text: viewStore.$accountName)
                            .modifier(TextFieldModifier())
                            .autocorrectionDisabled(true)
                            .focused($focusState, equals: .accountName)
                        
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
                            
                            TextField("Account ID", text: viewStore.$accountId)
                                .modifier(TextFieldModifier())
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .focused($focusState, equals: .accountId)
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
                            .foregroundStyle(viewStore.isEnableNextButton ? .white : .white.opacity(0.3))
                            .background(viewStore.isEnableNextButton ? Color.mainBaseColor : .gray.opacity(0.5))
                            .cornerRadius(.infinity)
                    }
                    .disabled(!viewStore.isEnableNextButton)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 80)
                
            }
            .navigationTitle("2 / 4")
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
                store: self.store.scope(state: \.$destination.profileImage,
                                        action: \.destination.profileImage)
            ) { store in
                self.profileImageView(store)
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        }
    }
}

