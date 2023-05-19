//
//  APIManaging.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 17.05.2023.
//

import Foundation

protocol APIManaging {
    func request<T: Codable>(_ request: URLRequest) async throws -> T
}
