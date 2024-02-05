//
//  TicketsReducerTest.swift
//
//
//  Created by 釘宮愼之介 on 2022/11/26.
//

import XCTest
import ComposableArchitecture
@testable import TicketFeature

@MainActor
class TicketsReducerTest: XCTestCase {
    func test_Initilize() async {
        let reducer = TicketsReducer()
        let before = TicketsState()
        let tickets = [
            Ticket(id: UUID(), title: "Ticket1"),
            Ticket(id: UUID(), title: "Ticket2"),
            Ticket(id: UUID(), title: "Ticket3"),
            Ticket(id: UUID(), title: "Ticket4"),
            Ticket(id: UUID(), title: "Ticket5"),
            Ticket(id: UUID(), title: "Ticket6")
        ]
        let store = TestStore(initialState: before, reducer: reducer)
        store.dependencies.ticketRepository = TicketRepository(fetch: {
            return tickets
        })

        await store.send(.initilize) {
            $0.loading = true
        }
        await store.receive(.fetched(tickets: IdentifiedArray(uniqueElements: tickets)), timeout: 1) {
            $0.tickets = TicketsBodyState(tickets: IdentifiedArray(uniqueElements: tickets))
        }
    }
}
