//
//  SwiftUIView.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import SwiftUI
import ComposableArchitecture
import PostDetailStore
import Assets
import Share
import ViewComponents

public struct PostDetailView: View {
    @Environment(\.openURL) var openURL
    
    private let store: StoreOf<PostDetail>
    private let gradient = Gradient(
        stops: [
            .init(color: Color(uiColor: UIColor(red: 53/255, green: 60/255, blue: 63/255, alpha: 1)), location: 0.0),
            .init(color: Color(uiColor: UIColor(red: 122/255, green: 151/255, blue: 163/255, alpha: 1)), location: 1.0)
        ]
    )
    
    public nonisolated init(store: StoreOf<PostDetail>) {
        self.store = store
        self.store.send(.initialize)
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                LinearGradient(
                    gradient: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack(spacing: 16) {
                        Spacer()
                        
                        // 共有ボタン
                        Button {
                            let renderer = ImageRenderer(content: body)
                            if let image = renderer.uiImage, let data = image.pngData() {
                                viewStore.send(.squareAndArrowUpButtonTapped(data))
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 22))
                                .bold()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                        
                        // 三点リーダ
                        Button {
                            viewStore.send(.ellipsisButtonTapped)
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 22))
                                .bold()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Text(viewStore.dateString)
                        Text("   |   ")
                        Text(viewStore.startToFinishTimeString)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Spacer()
                    
                    Text(viewStore.annotation.freeText)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                    
                    Spacer()
                    
                    if viewStore.annotation.postImagePath.isEmpty {
                        Image(uiImage: UIImage(named: "noImage")!)
                            .tint(.white)
                            .frame(width: 200, height: 200)
                    } else {
                        AsyncImage(
                            url: URL(string: viewStore.annotation.postImagePath)
                        ) { image in
                            image
                                .resizable()
                                .frame(width: 200, height: 200)
                        } placeholder: {
                            ProgressView()
                                .tint(.white)
                                .frame(width: 200, height: 200)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        AsyncImage(
                            url: URL(string: viewStore.annotation.postUserProfileImagePath)
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(1,contentMode: .fit)
                                .clipShape(Circle())
                                .frame(
                                    width: UIScreen.main.bounds.width*0.15,
                                    height: UIScreen.main.bounds.width*0.15
                                )
                        } placeholder: {
                            Image(uiImage: UIImage(named: "noImage")!)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(Circle())
                                .frame(
                                    width: UIScreen.main.bounds.width*0.15,
                                    height: UIScreen.main.bounds.width*0.15
                                )
                        }
                        
                        VStack {
                            Text(viewStore.annotation.postUserAccountName)
                            Text(viewStore.annotation.postUserAccountId)
                        }
                        .foregroundColor(.white)
                        .bold()
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
            }
            .confirmationDialog("その他", isPresented: viewStore.$isShownActionSheet) {
                if viewStore.isMine {
                    Button("投稿の削除") {
                        viewStore.send(.deletePostButtonTapped)
                    }
                } else {
                    Button("通報") {
                    #if DEBUG
                        // シュミレータでは表示できない
                    #else
                        if MailView.canSendMail() {
                            viewStore.send(.reportButtonTapped)
                        } else {
                            // TODO: MailViewを表示できない場合に開く先
                            openURL(URL(string: "https://qiita.com/SNQ-2001")!)
                        }
                    #endif
                    }
                    Button("ブロック") {
                        // ブロック処理
                        viewStore.send(.blockButtonTapped)
                    }
                }
            }
            .sheet(isPresented: viewStore.$isShownMailView) {
                // TODO: メールの中身
                MailView(
                    address: ["inemuri.app@gmail.com"],
                    subject: "サンプルアプリ",
                    body: "サンプルアプリです"
                )
                .edgesIgnoringSafeArea(.all)
            }
            .alert(
                store: store.scope(state: \.$alert,
                                   action: \.alert)
            )
            .actionSheet(
                store: store.scope(state: \.$actionSheet,
                                   action: \.actionSheet)
            )
            .popover(isPresented: viewStore.$isShowSharePopover) {
                ShareView(imageData: viewStore.shareRenderedImageData!, description: "")
            }
        }
    }
}
