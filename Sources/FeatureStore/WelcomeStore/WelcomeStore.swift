//
//  Welcome.swift
//  
//
//  Created by toya.suzuki on 2024/03/20.
//

import ComposableArchitecture
import API
import UserDefaults
import MailAddressPasswordStore
import AccountIdNameStore
import SelectModeStore

@Reducer
public struct Welcome {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        public var requiredInfo: GetRequiredInfoResponse
        
        public init(requiredInfo: GetRequiredInfoResponse) {
            self.requiredInfo = requiredInfo
        }
    }
    
    public enum Action: BindableAction {
        case initialize
        case signInButtonTapped
        case loginButtonTapped
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
    }
    
    // MARK: - Dependencies
    @Dependency(\.userDefaults) var userDefaults
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                // SessionID がローカルに存在しない場合は、何もしない
                if userDefaults.sessionId == nil {
                    print("check: No Session ID")
                    return .none
                }
                 
                /* 
                 セッションIDはローカルに存在するが、アカウントID・アカウント名が取得できない場合は、
                 アカウントID・アカウント名登録画面に遷移する
                 */
                if state.requiredInfo.accountId.isEmpty || state.requiredInfo.accountName.isEmpty {
                    state.destination = .accountIdName(AccountIdName.State())
                    return .none
                }
                
                /*
                 セッションIDはローカルに存在しアカウントID・アカウント名も取得できているが、アカウント種別が取得できない場合は、
                 アカウント種別登録画面に遷移する
                 */
                if state.requiredInfo.accounType.isEmpty {
                    state.destination = .selectMode(SelectMode.State())
                    return .none
                }
                
                // TODO: ここは通らない想定だが、本当にそうか確認する
                fatalError()
                
            case .signInButtonTapped:
                state.destination = .mailAddressPassword(MailAddressPassword.State(isLogin: false))
                return .none
            case .loginButtonTapped:
                state.destination = .mailAddressPassword(MailAddressPassword.State(isLogin: true))
                return .none
            case .binding:
                return .none
            case .destination(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}

extension Welcome {
    @Reducer(state: .equatable)
    public enum Path {
        case mailAddressPassword(MailAddressPassword)
        case accountIdName(AccountIdName)
        case selectMode(SelectMode)
    }
}
