//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 23/05/24.
//

import Foundation

@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
class WebRequest {
    
    func validateTable(_ table: CustomStringConvertible) throws {
        guard !table.description.isEmpty else { throw FMProErrors.tableNameMissing }
    }

    func validateNumber(_ number: Int) throws {
        guard number >= 0 else { throw FMProErrors.negativeNumber }
    }

    func validateField(_ field: CustomStringConvertible) throws {
        guard !field.description.isEmpty else { throw FMProErrors.fieldNameMissing }
    }
    
    /// Validates the index name to ensure it meets certain criteria.
    /// Example validation: Ensure the index name is not empty and contains only alphanumeric characters.
    func validateIndex(_ index: CustomStringConvertible) throws {
        let indexString = index.description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !indexString.isEmpty else {
            throw FMProErrors.indexMissing
        }
        // Example additional validation criteria
        let alphanumericSet = CharacterSet.alphanumerics
        guard indexString.rangeOfCharacter(from: alphanumericSet.inverted) == nil else {
            throw FMProErrors.invalidIndex
        }
    }
    
    /// Validates the query to ensure it's not empty.
    func validateQuery(_ query: CustomStringConvertible) throws {
        guard !query.description.isEmpty else {
            throw FMProErrors.queryExecutionFailed
        }
    }
    
    @discardableResult
    func performRequest<T: Codable>(api: FileMakerProtocol, endpoint: CustomStringConvertible, method: HTTPMethod, responseType: T.Type, data: T? = nil) async throws -> T {
        let urlString = "\(api.baseURL.absoluteString)\(endpoint.description)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        addBasicAuthHeader(to: &request, basicAuthCredentials: api.basicAuthCredentials)
        if let data = data {
            addRequestBodyAndContentType(to: &request, with: try JSONEncoder().encode(data))
        }
        do {
            let responseData = try await fetchData(for: request, method: method)
            if method == .delete {
                return responseData.isEmpty as! T
            }
            return try decodeResponse(responseData, to: T.self)
        } catch {
            throw FMProErrors.requestFailed
        }
    }
    
    func addBasicAuthHeader(to request: inout URLRequest, basicAuthCredentials: (String, String)?) {
        if let (username, password) = basicAuthCredentials {
            let loginString = "\(username):\(password)"
            if let loginData = loginString.data(using: .utf8)?.base64EncodedString() {
                request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    func addRequestBodyAndContentType(to request: inout URLRequest, with data: Data) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
    }
    
    func performDataTask(with request: URLRequest) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: NSError(domain: "AppErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                }
            }
            task.resume()
        }
    }
    
    func fetchData(for request: URLRequest, method: HTTPMethod) async throws -> Data {
        switch method {
        case .get, .delete:
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        case .post, .patch:
            return try await performDataTask(with: request)
        }
    }
    
    func getElementTypeName<T>(of value: T) -> String {
        let mirror = Mirror(reflecting: value)
        if let displayStyle = mirror.displayStyle {
            switch displayStyle {
            case .collection, .set, .dictionary:
                if let firstChild = mirror.children.first {
                    return String(describing: type(of: firstChild.value))
                }
            default:
                break
            }
        }
        let typeDescription = String(describing: T.self)
        if let range = typeDescription.range(of: "<.*>", options: .regularExpression) {
            let genericType = typeDescription[range]
            return String(genericType.dropFirst().dropLast())
        }
        return typeDescription
    }
    
    func decodeResponse<T: Codable>(_ data: Data, to type: T.Type) throws -> T {
        if T.self == Data.self {
            return data as! T
        } else {
            if type is any ExpressibleByArrayLiteral.Type {
                return try JSONDecoder().decode(JSONValue<T>.self, from: data).value
            } else {
                return try JSONDecoder().decode(T.self, from: data)
            }
        }
    }
}

