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
    
    private let userId = UserDefaults(suiteName: "group.inemuri")?.integer(forKey: "UserIdKey")
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
                MailView(
                    address: ["inemuri.app@gmail.com"],
                    subject: "アカウント削除",
                    body: "削除ID: \(userId ?? .zero) (書き換え厳禁) \n このままご送信ください。運営側でアカウントの削除を行います。\n削除完了まで今しばらくお待ちください。"
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
