//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 17/06/24.
//

import Foundation

@available(iOS 13.0.0, *)
@available(macOS 13.0, *)
extension FMOdataApi {
    /// Returns all the Metadata saved inside the database as Data encoded in an XML file.
    /// - Returns: The encoded XML file as Data.
    func getMetadataAsData() async throws -> Data {
        let endpoint = "$metadata"
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .get, responseType: Data.self)
    }
    
    /// Returns all the Metadata saved inside the database as a String.
    /// - Returns: The XML file as a String.
    func getMetadataAsString() async throws -> String? {
        let endpoint = "$metadata"
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .get, responseType: String.self)
    }

    /// Returns an array of TableValue containing information about all the tables inside the database.
    /// - Returns: An array of TableValue.
    func getListOfTables() async throws -> [TableValue] {
        return try await webRequestHelper.performRequest(api: self, endpoint: "", method: .get, responseType: [TableValue].self)
    }
}
