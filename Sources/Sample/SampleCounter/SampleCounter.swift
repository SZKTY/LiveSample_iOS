//
//  SampleCounter.swift
//
//
//  Created by toya.suzuki on 2024/03/16.
//

import Foundation
import ComposableArchitecture

public struct SampleCounter: Reducer {
    public struct State: Equatable {
        public var counter = 0
        
        public init() {}
    }
    
    public enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.counter += 1
                return .none
            case .incrementButtonTapped:
                state.counter += 1
                return .none
            }
        }
    }
}
