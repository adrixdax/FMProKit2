//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 23/05/24.
//

import Foundation

@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
internal extension FileMakerProtocol {
    func decodeResponse<T: Codable>(_ data: Data, to type: T.Type) throws -> T {
        if type is any ExpressibleByArrayLiteral.Type {
            return try JSONDecoder().decode(JSONValue<T>.self, from: data).value
        } else {
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
