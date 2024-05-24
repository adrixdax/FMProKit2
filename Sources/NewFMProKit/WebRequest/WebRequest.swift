//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 23/05/24.
//

import Foundation

@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
internal extension FMOdataApi {
    
    func sendRequest<T: Codable>(_ endpoint: String, method: HTTPMethod, responseType: T.Type, data: [String: Any]? = nil) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        addBasicAuthHeader(to: &request)
        addRequestBodyAndContentType(to: &request, with: data)
        let responseData = try await fetchData(for: request)
        return try decodeResponse(responseData, to: T.self)
    }
    
    func addBasicAuthHeader(to request: inout URLRequest) {
        if let (username, password) = basicAuthCredentials {
            let loginString = "\(username):\(password)"
            if let loginData = loginString.data(using: .utf8)?.base64EncodedString() {
                request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    func addRequestBodyAndContentType(to request: inout URLRequest, with data: [String: Any]?) {
        if let data = data {
            request.httpBody = try? JSONSerialization.data(withJSONObject: data)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    func fetchData(for request: URLRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
