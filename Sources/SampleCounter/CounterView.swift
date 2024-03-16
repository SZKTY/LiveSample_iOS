//
//  CounterView.swift
//
//
//  Created by toya.suzuki on 2024/03/16.
//

import SwiftUI
import ComposableArchitecture

public struct CounterView: View {
    let store: StoreOf<Counter>
    
    public init(store: StoreOf<Counter>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: \.counter) { counter in
            VStack {
                Text("\(counter.state)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        store.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        store.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}
