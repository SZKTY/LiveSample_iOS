//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct Root {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
            }
        }
    }
}


