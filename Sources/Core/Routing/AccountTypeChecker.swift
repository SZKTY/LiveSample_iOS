//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/20.
//

import Foundation

public class AccountTypeChecker: ObservableObject {
    public enum AccountType {
        case artist
        case fan
    }
    
    @Published public var accountType: AccountType = .fan
    
    public init() {
        reload()
    }
    
    public func reload() {
        guard let accountTypeString = UserDefaults(suiteName: "group.inemuri")?.string(forKey: "AccountTypeKey") else { return }
        self.accountType = getAccountType(from: accountTypeString)
    }
    
    private func getAccountType(from typeString: String) -> AccountType {
        switch typeString {
        case "artist":
            return .artist
        case "fan":
            return .fan
        default:
            return .fan
        }
    }
}
