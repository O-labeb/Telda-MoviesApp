//
//  Networker.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Alamofire

enum Networker {}

extension Networker {
    static func fetchData<D: Decodable>(at url: String, with input: Encodable?, completion: @escaping (Result<D, NetworkError>) -> Void) {
        AF.request(
            url,
            method: .get,
            parameters: try? input?.asDictionary()
        )
        .validate()
        .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                guard
                    let output = try? JSONDecoder.defaultDecoder.decode(D.self, from: data) else {
                    completion(.failure(.server(errorMessage: "Failed to decode response")))
                    return
                }
                
                completion(.success(output))
            case .failure(let error):
                guard
                    let data = response.data,
                    let networkError = try? JSONDecoder.defaultDecoder.decode(NetworkError.self, from: data)
                else {
                    completion(.failure(.server(errorMessage: error.localizedDescription)))
                    return
                }
                
                completion(.failure(networkError))
            }
        })
    }
}
