//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/28.
//

import SwiftUI
import ComposableArchitecture
import EditProfileStore
import Assets
import ViewComponents
import Routing
import PopupView

@MainActor
public struct EditProfileView: View {
    enum FocusStates {
        case accountId, accountName
    }
    
    @FocusState private var focusState : FocusStates?
    private let store: StoreOf<EditProfile>
    
    public nonisolated init(store: StoreOf<EditProfile>) {
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
                    
                    HStack {
                        Spacer()
                        
                        RemovableCircleImageButton(tapAction: {
                            viewStore.send(.didTapShowImagePicker)
                        }, removeAction: {
                            // Do Nothing
                        }, image: viewStore.$imageData, ration: 0.7, isShownDeleteButton: false)
                        
                        Spacer()
                    }
                    
                    Divider()
                        .padding()
                    
                    VStack(spacing: 8) {
                        DisablePasteTextField(placeHolder: "Your Name", text: viewStore.$accountName)
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
                            
                            DisablePasteTextField(placeHolder: "Account ID", text: viewStore.$accountId)
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
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewStore.send(.saveButtonTapped)
                        }) {
                            Text("保存")
                                .frame(width: 120.0, height: 60.0)
                                .font(.system(size: 16, weight: .medium))
                                .bold()
                                .foregroundStyle(.white)
                                .background(viewStore.isEnableSaveButton ? Color.mainBaseColor : Color.inactiveColor)
                                .cornerRadius(6)
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                        }
                        .disabled(!viewStore.isEnableSaveButton)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 80)
                
            }
            .disabled(viewStore.isBusy)
            .navigationTitle("プロフィール変更")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            store.send(.dismiss)
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 17, weight: .medium))
                        }
                    ).tint(.black)
                }
            }
            .task {
                store.send(.initialize)
            }
            .alert(store: store.scope(state: \.$alert, action: \.alert))
            .sheet(isPresented: viewStore.$isShownImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: viewStore.$imageData) {
                    store.send(.newImageSelected)
                }.ignoresSafeArea(edges: [.bottom])
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


