//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 17/06/24.
//

import Foundation

@available(macOS 12.0, *)
@available(iOS 13.0, *)
extension FMOdataApi {
    /// Execute a generic Delete query
    /// - Parameter query: An OData query used to filter the API call
    func executeQueryDelete(query: String) async throws -> Bool {
        try webRequestHelper.validateQuery(query)
        return try await webRequestHelper.performRequest(api: self, endpoint: query, method: .delete, responseType: Bool.self)
    }

    /// Execute a generic Get query
    /// - Parameter query: An OData query used to filter the API call
    /// - Returns: An array of Model type after fetching all the data
    func executeQueryGet<T: Codable>(query: String) async throws -> T {
        try webRequestHelper.validateQuery(query)
        return try await webRequestHelper.performRequest(api: self, endpoint: query, method: .get, responseType: T.self)
    }

    /// Execute a generic Patch query
    /// - Parameters:
    ///   - query: An OData query used to filter the API call
    ///   - data: the record of model T type with all the changes
    func executeQueryPatch<T: Codable>(query: String, data: T) async throws -> T {
        try webRequestHelper.validateQuery(query)
        return try await webRequestHelper.performRequest(api: self, endpoint: query, method: .patch, responseType: T.self, data: data)
    }


    /// Execute a generic Post query
    /// - Parameters:
    ///   - query: An OData query used to filter the API call
    ///   - data: the record of model T type with all the changes
    func executeQueryPost<T: Codable>(query: String, data: T) async throws -> T {
        try webRequestHelper.validateQuery(query)
        return try await webRequestHelper.performRequest(api: self, endpoint: query, method: .post, responseType: T.self, data: data)
    }

}
