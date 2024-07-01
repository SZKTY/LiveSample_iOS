//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/18.
//

import ComposableArchitecture
import Dependencies
import DependenciesMacros
import SwiftUI
import AccountIdNameStore
import MailAddressPasswordStore
import ProfileImageStore
import SelectModeStore
import WelcomeStore
import MapStore
import MyPageStore
import EditProfileStore
import PostStore
import PostDetailStore
import MapWithCrossStore

@DependencyClient
public struct ViewBuildingClient {
    // Test でunimplemented()を使用するためデフォルト値が必要なため "= {}"を追加している
    public var accountIdNameView: @Sendable (_ store: StoreOf<AccountIdName>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var mailAddressPasswordView: @Sendable (_ store: StoreOf<MailAddressPassword>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var profileImageView: @Sendable (_ store: StoreOf<ProfileImage>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var selectModeView: @Sendable (_ store: StoreOf<SelectMode>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var welcomeView: @Sendable (_ store: StoreOf<Welcome>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var mapView: @Sendable (_ store: StoreOf<MapStore>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var myPageView: @Sendable (_ store: StoreOf<MyPage>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var editProfileView: @Sendable (_ store: StoreOf<EditProfile>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var postView: @Sendable (_ store: StoreOf<PostStore>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var postDetailView: @Sendable (_ store: StoreOf<PostDetail>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var mapWithCrossView: @Sendable (_ store: StoreOf<MapWithCrossStore>) -> AnyView = { _ in AnyView(EmptyView()) }
}

// MARK: - Dependnecies

extension ViewBuildingClient: TestDependencyKey {
    public static let testValue = Self()
}

extension DependencyValues {
    public var viewBuildingClient: ViewBuildingClient {
        get { self[ViewBuildingClient.self] }
        set { self[ViewBuildingClient.self] = newValue }
    }
}
