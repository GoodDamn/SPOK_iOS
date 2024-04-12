//
//  String.swift
//  SPOK
//
//  Created by GoodDamn on 04/02/2024.
//

import Foundation

extension String {
    
    func iso8601Epoch() -> Int {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [
            .withFullDate,
            .withTime,
            .withFractionalSeconds,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
        
        let d = iso.date(
            from: self
        )?.timeIntervalSince1970 ?? 0
        
        return Int(d)
    }
    
    static func locale(
        _ key: String
    ) -> String {
        return NSLocalizedString(
            key,
            tableName: "Localization",
            bundle: Bundle.main,
            value: "",
            comment: ""
        )
    }
    
    static func lang() -> String {
        return Locale
            .current
            .languageCode?
            .replacingOccurrences(
                of: "ru",
                with: "")
            .uppercased() ?? ""
    }
    
}
