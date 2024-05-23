//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 23/05/24.
//

import Foundation

@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
extension FMOdataApi {
    
    public func getTable<T: Codable>(_ name: String) async throws -> T {
        let url = baseURL.appendingPathComponent(name)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        addBasicAuthHeader(to: &request)
        let responseData = try await fetchData(for: request)
        return try decodeResponse(responseData, to: T.self)
    }

}
