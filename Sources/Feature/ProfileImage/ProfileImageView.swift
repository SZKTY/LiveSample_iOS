//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import SwiftUI
import ComposableArchitecture
import ViewComponents
import ProfileImageStore
import Routing

@MainActor
public struct ProfileImageView: View {
    @Dependency(\.viewBuildingClient.selectModeView) var selectModeView
    let store: StoreOf<ProfileImage>
    
    public nonisolated init(store: StoreOf<ProfileImage>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                Text("プロフィール写真を選択してください")
                    .font(.system(size: 20, weight: .black))
                    .padding(.bottom, 20)
                
                HStack {
                    Image(uiImage: UIImage(data: viewStore.imageData) ?? UIImage(named: "noImage")!)
                        .resizable()
                        .aspectRatio(1,contentMode: .fit)
                        .clipShape(Circle())
                        .frame(
                            width: UIScreen.main.bounds.width*0.5,
                            height: UIScreen.main.bounds.width*0.5
                        )
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: {
                        store.send(.didTapShowImagePicker)
                    }) {
                        Text("ライブラリから\n選択")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 17, weight: .medium))
                    }
                    .accentColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(.infinity)
                    
                    Button(action: {
                        store.send(.didTapShowSelfImagePicker)
                    }) {
                        Text("写真を撮る")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 17, weight: .medium))
                    }
                    .accentColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(.infinity)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    store.send(.nextButtonTapped)
                }) {
                    Text("次へ")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                }
                .accentColor(Color.white)
                .background(Color.black)
                .cornerRadius(.infinity)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 80)
            .sheet(isPresented: viewStore.$isShownImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: viewStore.$imageData)
            }
            .sheet(isPresented: viewStore.$isShownSelfImagePicker) {
                ImagePicker(sourceType: .camera, selectedImage: viewStore.$imageData)
            }
            .background(
                Image("mainBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarBackButtonHidden(true)
            .navigationDestination(
                store: store.scope(state: \.$destination.selectMode,
                                   action: \.destination.selectMode)
            ) { store in
                self.selectModeView(store)
            }
        }
    }
}
