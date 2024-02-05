//
//  TicketRepository.swift
//
//
//  Created by 釘宮愼之介 on 2022/11/23.
//

import Foundation
import Dependencies

public struct TicketRepository: Sendable {
    public var fetch: @Sendable () async throws -> [Ticket]
}

extension TicketRepository: DependencyKey {
    public static let liveValue = Self(
        fetch: {
            return [
                Ticket(id: UUID(), title: "Ticket1"),
                Ticket(id: UUID(), title: "Ticket2"),
                Ticket(id: UUID(), title: "Ticket3"),
                Ticket(id: UUID(), title: "Ticket4"),
                Ticket(id: UUID(), title: "Ticket5"),
                Ticket(id: UUID(), title: "Ticket6")
            ]
        }
    )
}

extension DependencyValues {
    public var ticketRepository: TicketRepository {
        get { self[TicketRepository.self] }
        set { self[TicketRepository.self] = newValue }
    }
}
