//
//  Networker.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Alamofire

enum Networker {}

extension Networker {
    @discardableResult static func fetchData<D: Decodable>(at url: String, with input: Encodable?, completion: @escaping (Result<D, NetworkError>) -> Void) -> Request {
        AF.request(
            url,
            method: .get,
            parameters: try? input?.asDictionary()
        )
        .validate()
        .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                do {
                    let output = try JSONDecoder.defaultDecoder.decode(D.self, from: data)
                    completion(.success(output))
                } catch(let error) {
                    completion(.failure(.server(errorMessage: "Failed to decode response ")))
                    print(error)
                }
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
