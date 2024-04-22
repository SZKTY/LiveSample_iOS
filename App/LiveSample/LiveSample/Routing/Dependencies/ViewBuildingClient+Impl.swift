//
//  ViewBuildingClient+Impl.swift
//  LiveSample
//
//  Created by toya.suzuki on 2024/04/18.
//

import ComposableArchitecture
import AccountId
import AccountName
import Home
import MailAddressPassword
import ProfileImage
import SelectMode
import Welcome
import Routing
import SwiftUI

extension ViewBuildingClient: DependencyKey {
    
    public static var liveValue: ViewBuildingClient {
        return .init(
            accountIdView: { store in
                AnyView(AccountIdView(store: store))
            },
            accountNameView:  { store in
                AnyView(AccountNameView(store: store))
            },
            homeView:  { store in
                AnyView(HomeView(store: store))
            },
            mailAddressPasswordView:  { store in
                AnyView(MailAddressPasswordView(store: store))
            },
            profileImageView:  { store in
                AnyView(ProfileImageView(store: store))
            },
            selectModeView:  { store in
                AnyView(SelectModeView(store: store))
            },
            welcomeView:  { store in
                AnyView(WelcomeView(store: store))
            }
        )
    }
}