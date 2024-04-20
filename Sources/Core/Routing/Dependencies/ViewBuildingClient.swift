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
import AccountIdStore
import AccountNameStore
import HomeStore
import MailAddressPasswordStore
import ProfileImageStore
import SelectModeStore
import WelcomeStore

@DependencyClient
public struct ViewBuildingClient {
    // Test でunimplemented()を使用するためデフォルト値が必要なため "= {}"を追加している
    public var accountIdView: @Sendable (_ store: StoreOf<AccountId>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var accountNameView: @Sendable (_ store: StoreOf<AccountName>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var homeView: @Sendable (_ store: StoreOf<Home>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var mailAddressPasswordView: @Sendable (_ store: StoreOf<MailAddressPassword>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var profileImageView: @Sendable (_ store: StoreOf<ProfileImage>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var selectModeView: @Sendable (_ store: StoreOf<SelectMode>) -> AnyView = { _ in AnyView(EmptyView()) }
    public var welcomeView: @Sendable (_ store: StoreOf<Welcome>) -> AnyView = { _ in AnyView(EmptyView()) }
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
