//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import Dependencies
import ComposableArchitecture

public struct ProfileImage: Reducer, Sendable {
    public struct State: Equatable {
        @BindingState public var isShownImagePicker: Bool = false
        @BindingState public var isShownSelfImagePicker: Bool = false
        @BindingState public var imageData: Data = Data()
        
        public init() {}
    }
    
    public enum Action: BindableAction, Equatable {
        case didTapShowImagePicker
        case didTapShowSelfImagePicker
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapShowImagePicker:
                state.isShownImagePicker.toggle()
                return .none
            case .didTapShowSelfImagePicker:
                state.isShownSelfImagePicker.toggle()
                return .none
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}

