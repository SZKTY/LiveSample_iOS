//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import PostStore

public struct PostView: View {
    let store: StoreOf<PostStore>
    
    public init(store: StoreOf<PostStore>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List {
                    // MARK: - Image
                    VStack(alignment: .leading) {
                        Text("画像")
                        
                        Spacer()
                            .frame(height: 20)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                print("check: Tapped")
                            }) {
                                Image(systemName: "camera")
                                    .padding()
                                    .font(.system(size: 20))
                                    .frame(width: 65, height: 65)
                                    .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(style: StrokeStyle(dash: [8,7])))
                                    .foregroundColor(Color.gray)
                                    .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("一言メッセージ")
                    }
                    
                    // MARK: - Message
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 20)
                        
                        TextField("Hoge", text: viewStore.$freeText)
                            .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("エリア")
                    }
                    
                    // MARK: - Area (in Map)
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 20)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                print("check: Tapped")
                            }) {
                                Image(systemName: "camera")
                                    .padding()
                                    .font(.system(size: 20))
                                    .frame(width: 65, height: 65)
                                    .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(style: StrokeStyle(dash: [8,7])))
                                    .foregroundColor(Color.gray)
                                    .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("時間（選択）")
                    }
                    
                    // MARK: - Time
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 20)
                        
                        DatePicker("開始", selection: viewStore.$startDate, displayedComponents: .hourAndMinute)
                            .padding(.horizontal, 20)
                        
                        DatePicker("終了", selection: viewStore.$startDate, displayedComponents: .hourAndMinute)
                            .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 20)
                    }
                    
                    // MARK: - Post
                    VStack {
                        Spacer()
                        
                        Button(action: {
                        }) {
                            Text("投稿する")
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.inset)
            .navigationTitle("投稿作成")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}