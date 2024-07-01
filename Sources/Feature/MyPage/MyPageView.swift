//
//  SwiftUIView.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import MyPageStore
import ViewComponents

public struct MyPageView: View {
    @Environment(\.openURL) var openURL
    
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    private let store: StoreOf<MyPage>
    
    public nonisolated init(store: StoreOf<MyPage>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                // MARK: - プロフィール編集
                HStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 22))
                    
                    Text("プロフィール編集")
                }
                .padding([.top, .horizontal])
                .listRowSeparator(.hidden)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewStore.send(.editProfileTapped)
                }
                
                // MARK: - アカウント削除
                HStack {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 22))
                    
                    Text("アカウントの削除")
                }
                .padding([.bottom, .horizontal])
                .alignmentGuide(.listRowSeparatorLeading) { _ in  0 }
                .listRowSeparator(.visible)
                .contentShape(Rectangle())
                .onTapGesture {
                #if DEBUG
                    // シュミレータでは表示できない
                #else
                    if MailView.canSendMail() {
                        viewStore.send(.deleteAccountTapped)
                    } else {
                        // TODO: MailViewを表示できない場合に開く先
                        openURL(URL(string: "https://qiita.com/SNQ-2001")!)
                    }
                #endif
                    
                }
                
                // MARK: - 利用規約
                HStack {
                    Image(systemName: "doc.text")
                        .font(.system(size: 22))
                    
                    Text("利用規約")
                }
                .padding([.top, .horizontal])
                .listRowSeparator(.hidden)
                .contentShape(Rectangle())
                .onTapGesture {
                    openURL(URL(string: "https://qiita.com/SNQ-2001")!)
                }
                
                // MARK: - プライバシーポリシー
                HStack {
                    Image(systemName: "lock.doc")
                        .font(.system(size: 22))
                    
                    Text("プライバシーポリシー")
                }
                .padding([.bottom, .horizontal])
                .alignmentGuide(.listRowSeparatorLeading) { _ in  0 }
                .listRowSeparator(.visible)
                .contentShape(Rectangle())
                .onTapGesture {
                    openURL(URL(string: "https://qiita.com/SNQ-2001")!)
                }
                
                // MARK: - お問い合わせ
                HStack {
                    Image(systemName: "mail")
                        .font(.system(size: 22))
                    
                    Text("お問い合わせ")
                }
                .padding()
                .alignmentGuide(.listRowSeparatorLeading) { _ in  0 }
                .listRowSeparator(.visible)
                .contentShape(Rectangle())
                .onTapGesture {
                    openURL(URL(string: "https://qiita.com/SNQ-2001")!)
                }
                
                // MARK: - バージョン
                HStack {
                    Text("バージョン：\(version)")
                }
                .padding()
                .alignmentGuide(.listRowSeparatorLeading) { _ in  0 }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .sheet(isPresented: viewStore.$isShownMailView) {
                // TODO: メールの中身
                MailView(
                    address: ["inemuri.app@gmail.com"],
                    subject: "サンプルアプリ",
                    body: "サンプルアプリです"
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
