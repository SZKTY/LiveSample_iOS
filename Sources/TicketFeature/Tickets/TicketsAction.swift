//
//  TicketsAction.swift
//
//
//  Created by 釘宮愼之介 on 2022/11/23.
//

import Foundation
import ComposableArchitecture

public enum TicketsAction: Equatable {
    case initilize
    case tapTicket(ticketId: UUID)
    case fetched(tickets: IdentifiedArrayOf<Ticket>)
}
