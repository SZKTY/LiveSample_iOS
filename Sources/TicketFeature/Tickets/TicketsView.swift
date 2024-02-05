//
//  TicketsView.swift
//
//
//  Created by 釘宮愼之介 on 2022/11/23.
//

import SwiftUI
import ComposableArchitecture

public struct TicketsView: View {
    let store: StoreOf<TicketsReducer>

    public init(store: StoreOf<TicketsReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            IfLetStore(
                store.scope(state: \.tickets),
                then: { ticketsBodyStore in
                    WithViewStore(ticketsBodyStore) { ticketsViewStore in
                        List(ticketsViewStore.tickets, id: \.id) { ticket in
                            Text(ticket.title)
                        }
                    }
                },
                else: {
                    ProgressView().onAppear { viewStore.send(.initilize) }
                }
            )
        }
    }
}
