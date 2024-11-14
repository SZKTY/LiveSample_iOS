//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/20.
//

import Foundation

public class DateUtils {
    private class func makeDateFormatter(format: String, isConvertToJa: Bool) -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(abbreviation: isConvertToJa ? "JST" : "UTC")
        formatter.dateFormat = format
        return formatter
    }
    
    public class func dateFromString(string: String, format: String, isConvertToJa: Bool = false) -> Date {
        let formatter: DateFormatter = Self.makeDateFormatter(format: format, isConvertToJa: isConvertToJa)
        return formatter.date(from: string)!
    }

    public class func stringFromDate(date: Date, format: String, isConvertToJa: Bool = false) -> String {
        let formatter: DateFormatter = Self.makeDateFormatter(format: format, isConvertToJa: isConvertToJa)
        return formatter.string(from: date)
    }
}
