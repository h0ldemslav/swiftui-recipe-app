//
//  APIManager.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 17.05.2023.
//

import Foundation

enum APIResponseStatus: Error {
    case NoResponse(message: String)
    case BadRequest(message: String)
    case Unauthorized(message: String)
    case Forbidden(message: String)
    case TooManyRequests(message: String)
    case ServerUnavailable(message: String)
    case Other(message: String)
}

final class APIManager: APIManaging {
    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder = JSONDecoder()
    
    func request<T>(_ request: URLRequest) async throws -> T where T: Codable {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIResponseStatus.NoResponse(message: "No HTTP response")
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            switch httpResponse.statusCode {
            case 400:
                throw APIResponseStatus.BadRequest(message: "Bad search query")
                
            case 401:
                throw APIResponseStatus.Unauthorized(message: "Invalid credentials")
                
            case 429:
                throw APIResponseStatus.TooManyRequests(message: "Too many queries, try again later")
                
            case 403:
                throw APIResponseStatus.Forbidden(message: "Action is forbidden")
                
            case 500..<600:
                throw APIResponseStatus.ServerUnavailable(message: "Server is unavailable")
                
            default:
                throw APIResponseStatus.Other(message: "Unknown response status, code \(httpResponse.statusCode)")
            }
        }

        let result = try decoder.decode(T.self, from: data)

        return result
    }
}
