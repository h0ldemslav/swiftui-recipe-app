//
//  APIManager.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 17.05.2023.
//

import Foundation


enum APIError: Error {
    case NoHTTPResponse
    case BadHTTPResponse
}

final class APIManager: APIManaging {
    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder = JSONDecoder()
    
    func request<T>(_ request: URLRequest) async throws -> T where T: Codable {        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.NoHTTPResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.BadHTTPResponse
        }
        
        let result = try decoder.decode(T.self, from: data)

        return result
    }
}
