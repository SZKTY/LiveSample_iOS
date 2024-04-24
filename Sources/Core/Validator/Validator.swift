//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import Foundation

public class Validator {
    public static func isEmail(_ email: String) -> Bool {
        let pattern = "^[\\w\\.\\-_]+@[\\w\\.\\-_]+\\.[a-zA-Z]+$"
        let matches = validate(str: email, pattern: pattern)
        return matches.count > 0
    }

    public static func isPassword(_ password: String) -> Bool {
        let pattern = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,20}$"
        let matches = validate(str: password, pattern: pattern)
        return matches.count > 0
    }

    private static func validate(str: String, pattern: String) -> [NSTextCheckingResult] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        return regex.matches(in: str, range: NSRange(location: 0, length: str.count))
    }
}
