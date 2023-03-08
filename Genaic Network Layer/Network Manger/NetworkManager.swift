//
//  NetworkManager.swift
//  Genaic Network Layer
//
//  Created by Madushan Senavirathna on 2023-03-08.
//

import Foundation
import Combine

class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case serverError(String)
        case unknown
    }
    
    func makeRequest<T: Decodable>(urlString: String,
                                   httpMethod: String,
                                   headers: [String: String] = [:],
                                   body: Data? = nil) -> AnyPublisher<T, NetworkError> {
        
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        
        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.unknown }
            .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse)
                        .eraseToAnyPublisher()
                }
                if (200...299).contains(httpResponse.statusCode) {
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError { _ in NetworkError.decodingError }
                        .eraseToAnyPublisher()
                } else if let message = String(data: data, encoding: .utf8) {
                    return Fail(error: NetworkError.serverError(message))
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: NetworkError.unknown)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

