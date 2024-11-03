//
//  ViewBuildingClient+Impl.swift
//  LiveSample
//
//  Created by toya.suzuki on 2024/04/18.
//

import ComposableArchitecture
import AccountIdName
import Login
import MailAddress
import Password
import AuthenticationCode
import ProfileImage
import SelectMode
import Welcome
import Routing
import Map
import MyPage
import EditProfile
import Post
import PostDetail
import MapWithCross
import SwiftUI

extension ViewBuildingClient: DependencyKey {
    
    public static var liveValue: ViewBuildingClient {
        return .init(
            accountIdNameView: { store in
                AnyView(AccountIdNameView(store: store))
            },
            loginView: { store in
                AnyView(LoginView(store: store))
            },
            mailAddressView: { store in
                AnyView(MailAddressView(store: store))
            },
            passwordView: { store in
                AnyView(PasswordView(store: store))
            },
            authenticationCodeView: { store in
                AnyView(AuthenticationCodeView(store: store))
            },
            profileImageView: { store in
                AnyView(ProfileImageView(store: store))
            },
            selectModeView: { store in
                AnyView(SelectModeView(store: store))
            },
            welcomeView: { store in
                AnyView(WelcomeView(store: store))
            },
            mapView: { store in
                AnyView(MapView(store: store))
            },
            myPageView: { store in
                AnyView(MyPageView(store: store))
            },
            editProfileView: { store in
                AnyView(EditProfileView(store: store))
            },
            postView: { store in
                AnyView(PostView(store: store))
            },
            postDetailView: { store in
                AnyView(PostDetailView(store: store))
            },
            mapWithCrossView: { store in
                AnyView(MapWithCrossView(store: store))
            }
        )
    }
}
