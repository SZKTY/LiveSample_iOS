//
//  TicketsState.swift
//
//
//  Created by 釘宮愼之介 on 2022/11/13.
//

import Foundation
import ComposableArchitecture

public struct TicketsState: Equatable {
    public var loading: Bool = false
    public var tickets: TicketsBodyState?

    public init() {}
}

public struct TicketsBodyState: Equatable {
    public var tickets: IdentifiedArrayOf<Ticket> = []
}

public struct Ticket: Equatable, Identifiable {
    public let id: UUID
    public let title: String
}
