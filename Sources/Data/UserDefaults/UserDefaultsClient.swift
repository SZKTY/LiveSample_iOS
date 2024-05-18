//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/11.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct UserDefaultsClient: Sendable {
    public var boolForKey: @Sendable (String) -> Bool = { _ in false }
    public var dataForKey: @Sendable (String) -> Data?
    public var doubleForKey: @Sendable (String) -> Double = { _ in 0 }
    public var integerForKey: @Sendable (String) -> Int = { _ in 0 }
    public var stringForKey: @Sendable (String) -> String?
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
    public var setString: @Sendable (String, String) async -> Void
    
    public var sessionId: String? {
        self.stringForKey(self.sessionIdKey)
    }

    public func setSessionId(_ string: String) async {
        await self.setString(string, sessionIdKey)
    }
    
    private let sessionIdKey = "SessionIdKey"
}

extension UserDefaultsClient: TestDependencyKey {
  public static let previewValue = Self.noop
  public static let testValue = Self()
}

extension UserDefaultsClient {
  public static let noop = Self(
    boolForKey: { _ in false },
    dataForKey: { _ in nil },
    doubleForKey: { _ in 0 },
    integerForKey: { _ in 0 },
    stringForKey: { _ in "" },
    remove: { _ in },
    setBool: { _, _ in },
    setData: { _, _ in },
    setDouble: { _, _ in },
    setInteger: { _, _ in },
    setString: { _, _ in }
  )

  public mutating func override(bool: Bool, forKey key: String) {
    self.boolForKey = { [self] in $0 == key ? bool : self.boolForKey($0) }
  }

  public mutating func override(data: Data, forKey key: String) {
    self.dataForKey = { [self] in $0 == key ? data : self.dataForKey($0) }
  }

  public mutating func override(double: Double, forKey key: String) {
    self.doubleForKey = { [self] in $0 == key ? double : self.doubleForKey($0) }
  }

  public mutating func override(integer: Int, forKey key: String) {
    self.integerForKey = { [self] in $0 == key ? integer : self.integerForKey($0) }
  }
    
    public mutating func override(string: String, forKey key: String) {
        self.stringForKey = { [self] in $0 == key ? string : self.stringForKey($0) }
    }
}

public extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

extension UserDefaultsClient: DependencyKey {
  public static let liveValue: Self = {
    let defaults = { UserDefaults(suiteName: "group.inemuri")! }
    return Self(
      boolForKey: { defaults().bool(forKey: $0) },
      dataForKey: { defaults().data(forKey: $0) },
      doubleForKey: { defaults().double(forKey: $0) },
      integerForKey: { defaults().integer(forKey: $0) },
      stringForKey: { defaults().string(forKey: $0) },
      remove: { defaults().removeObject(forKey: $0) },
      setBool: { defaults().set($0, forKey: $1) },
      setData: { defaults().set($0, forKey: $1) },
      setDouble: { defaults().set($0, forKey: $1) },
      setInteger: { defaults().set($0, forKey: $1) },
      setString: { defaults().set($0, forKey: $1) }
    )
  }()
}
