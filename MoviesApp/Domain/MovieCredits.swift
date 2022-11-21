//
//  PopularMovies.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

struct MovieCredits: Decodable {
    let cast: [Individual]
    let crew: [Individual]
}

extension MovieCredits {
    struct Individual: Decodable {
        let name: String
        let popularity: Double
        let role: Role
        
        enum CodingKeys: String, CodingKey {
            case name, popularity
            case role = "knownForDepartment"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.popularity = try container.decode(Double.self, forKey: .popularity)
            
            if (try? container.decode(String.self, forKey: .role)) == "Acting" {
                self.role = .actor
            } else if (try? container.decode(String.self, forKey: .role)) == "Directing" {
                self.role = .director
            } else {
                self.role = .other
            }
        }
    }
}

extension MovieCredits.Individual: Comparable {
    static func < (lhs: MovieCredits.Individual, rhs: MovieCredits.Individual) -> Bool {
        lhs.popularity < rhs.popularity
    }
}

extension MovieCredits.Individual {
    enum Role: Decodable {
        case actor
        case director
        case other
    }
}
