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
    func decodeResponse<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        if let singleObject = try? JSONDecoder().decode(T.self, from: data) {
            return singleObject
        } else {
            return try JSONDecoder().decode([T].self, from: data) as! T
        }
    }
}
