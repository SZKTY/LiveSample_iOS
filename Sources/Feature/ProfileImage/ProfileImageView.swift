//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import ProfileImageStore
import Assets
import ViewComponents
import Routing

@MainActor
public struct ProfileImageView: View {
    @Environment(\.dismiss) var dismiss
    
    @Dependency(\.viewBuildingClient.selectModeView) var selectModeView
    
    let store: StoreOf<ProfileImage>
    
    public nonisolated init(store: StoreOf<ProfileImage>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 60) {
                Spacer()
                
                Text("プロフィール写真を選択してください")
                    .font(.system(size: 20, weight: .heavy))
                
                VStack(spacing: 36) {
                    HStack {
                        RemovableCircleImageButton(tapAction: {
                            viewStore.send(.didTapShowImagePicker)
                        }, removeAction: {
                            viewStore.send(.imageRemoveButtonTapped)
                        }, image: viewStore.imageData)
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            store.send(.didTapShowImagePicker)
                        }) {
                            Text("ライブラリから\n選択")
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .font(.system(size: 17))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.black, lineWidth: 1)
                                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                )
                        }
                        
                        Button(action: {
                            store.send(.didTapShowSelfImagePicker)
                        }) {
                            Text("写真を撮る")
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .font(.system(size: 17))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.black, lineWidth: 1)
                                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                )
                        }
                    }
                }
                
                Button(action: {
                    store.send(.nextButtonTapped)
                }) {
                    Text("次へ")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                        .bold()
                        .foregroundStyle(.white)
                        .background(viewStore.imageData != Data() ? Color.mainBaseColor : Color.inactiveColor)
                        .cornerRadius(.infinity)
                }
                .disabled(viewStore.imageData == Data())
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color.mainSubColor)
            .navigationTitle("3 / 4")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            store.send(.skipButtonTapped)
                        }, label: {
                            Text("Skip")
                        }
                    ).tint(.black)
                }
            }
            .sheet(isPresented: viewStore.$isShownImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: viewStore.$imageData)
            }
            .sheet(isPresented: viewStore.$isShownSelfImagePicker) {
                ImagePicker(sourceType: .camera, selectedImage: viewStore.$imageData)
            }
            .alert(store: store.scope(state: \.$alert, action: \.alert))
            .navigationDestination(
                store: store.scope(state: \.$destination.selectMode,
                                   action: \.destination.selectMode)
            ) { store in
                selectModeView(store)
            }
        }
    }
}
