//
//  TicketsReducer.swift
//
//
//  Created by 釘宮愼之介 on 2022/11/13.
//

import Foundation
import ComposableArchitecture

public struct TicketsReducer: ReducerProtocol {

    public init() {}

    public typealias State = TicketsState

    public typealias Action = TicketsAction

    @Dependency(\.ticketRepository) var ticketRepository

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .initilize:
            state.loading = true
            return .task {
                let tickets = try await ticketRepository.fetch()
                return .fetched(tickets: IdentifiedArray(uniqueElements: tickets))
            }
        case .fetched(let tickets):
            state.tickets = TicketsBodyState(tickets: tickets)
            return .none
        case .tapTicket(let ticketId):
            // todo: 画面遷移
            return .none
        }
    }
}
