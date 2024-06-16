//
//  SwiftUIView.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import SwiftUI
import ComposableArchitecture
import PostDetailStore

public struct PostDetailView: View {
    let store: StoreOf<PostDetail>
    
    public nonisolated init(store: StoreOf<PostDetail>) {
        self.store = store
        
        self.store.send(.initialize)
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .topTrailing) {
                  Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("ライブ")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: 28))
                        .padding(.top, 20)
                    
                    Spacer()
                    
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
                    
                    AsyncImage(url: URL(string: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhTmqAJRd4sTUbjFb9ViRzDcc2znBcYMTSZmBeXcqnZesbU3B3njNfx8WSeDAeyMoVzNQLqjsSg4FwdBbJ3vdT7Hq1S1X7_3hFYUov8VdgiftoJtWYckaDb9CqotWECCmLeFd9RiFDHnXyR/s180-c/buranko_boy_sad.png")) { image in
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                    
                    Spacer()
                    
                    HStack {
                        AsyncImage(url: URL(string: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhTmqAJRd4sTUbjFb9ViRzDcc2znBcYMTSZmBeXcqnZesbU3B3njNfx8WSeDAeyMoVzNQLqjsSg4FwdBbJ3vdT7Hq1S1X7_3hFYUov8VdgiftoJtWYckaDb9CqotWECCmLeFd9RiFDHnXyR/s180-c/buranko_boy_sad.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(1,contentMode: .fit)
                                .clipShape(Circle())
                                .frame(
                                    width: UIScreen.main.bounds.width*0.15,
                                    height: UIScreen.main.bounds.width*0.2
                                )
                        } placeholder: {
                            ProgressView()
                                .frame(
                                    width: UIScreen.main.bounds.width*0.15,
                                    height: UIScreen.main.bounds.width*0.15
                                )
                        }
                        
                        VStack {
                            Text("account_name")
                            Text("account_id")
                        }
                        .foregroundColor(.white)
                        .bold()
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // 三点リーダ
                Button {
                    viewStore.send(.ellipsisButtonTapped)
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 28.0, leading: 0, bottom: 0, trailing: 28.0))
                }
            }
            .confirmationDialog("その他", isPresented: viewStore.$isShownActionSheet) {
                Button("選択肢1") {
                    // 選択肢1ボタンが押された時の処理
                }
                Button("選択肢2") {
                    // 選択肢2ボタンが押された時の処理
                }
            }
        }
    }
}
