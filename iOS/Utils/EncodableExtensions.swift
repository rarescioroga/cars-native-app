//
//  EncodableExtensions.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

extension Encodable {
    
    subscript(key: String) -> Any? {
        return params[key]
    }
    
    var params: [String: Any] {
        let encoder = JSONEncoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(DateFormatter.yearMonthDayFormatter)
        return (try? JSONSerialization.jsonObject(with: encoder.encode(self))) as? [String: Any] ?? [:]
    }
    
    var data: Data? {
        let encoder = JSONEncoder()
        let jsonObject = (try? JSONSerialization.jsonObject(with: encoder.encode(self))) as? [String: Any] ?? [:]
        let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
        return data
    }
    
}
