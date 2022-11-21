//
//  NetworkError.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

enum NetworkError: Error, Decodable {
    case backend(backendStatusCode: Int, message: String)
    case server(errorMessage: String?)
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case statusMessage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if
            let message = try? container.decode(String.self, forKey: .statusMessage),
            let statusCode = try? container.decode(Int.self, forKey: .statusCode) {
            self = .backend(backendStatusCode: statusCode, message: message)
        } else {
            self = .server(errorMessage: nil)
        }
    }
}
