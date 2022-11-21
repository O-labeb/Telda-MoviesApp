//
//  JsonDecoder.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension JSONDecoder {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom({ try decodeDate(from: $0) })
        return decoder
    }
    
    private static func decodeDate(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateStr) ?? Date()
    }
}
