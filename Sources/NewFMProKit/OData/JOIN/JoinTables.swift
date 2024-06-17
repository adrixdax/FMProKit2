//
//  JoinTables.swift
//
//
//  Created by Adriano d'Alessandro on 24/05/24.
//

import Foundation

@available(iOS 13.0.0, *)
@available(macOS 13.0, *)
extension FMOdataApi {
        
    func getTableCrossJoin<T: Codable>(listOfTables: [CustomStringConvertible], fetchedTable: CustomStringConvertible? = nil, query: CustomStringConvertible? = nil, to type: T.Type) async throws -> T {
        return try await self.webRequestHelper.performRequest(api: self, endpoint: 
            "$crossjoin(\(listOfTables.map { $0.description }.joined(separator: ",")))?\(query.map { "$\($0)" } ?? "")&$expand=\(getElementTypeName(of: T.self))($select=*)",
            method: .get,
            responseType: T.self
        )
    }
}
