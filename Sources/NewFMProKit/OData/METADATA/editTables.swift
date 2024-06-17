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
    /// Create a new table in the database schema.
    func createNewTable(tableName: String, listOfColumns: [CreationTableField]) async throws {
        try webRequestHelper.validateTable(tableName)
        for tableFied in listOfColumns {
            try webRequestHelper.validateField(tableFied.name)
        }
        _ = try await webRequestHelper.performRequest(api: self, endpoint: "FileMaker_Tables", method: .post, responseType: CreationTableField.self)
    }

    /// Add columns to an existing table.
    func addColumnToTable(tableName: String, listOfColumns: [CreationTableField]) async throws {
        try webRequestHelper.validateTable(tableName)
        for tableFied in listOfColumns {
            try webRequestHelper.validateField(tableFied.name)
        }
        _ = try await webRequestHelper.performRequest(api: self, endpoint: "FileMaker_Tables/\(tableName)", method: .patch, responseType: CreationTableField.self)
    }

    /// Delete a table by its name.
    func deleteTable(tableName: String) async throws {
        try webRequestHelper.validateTable(tableName)
        _ = try await webRequestHelper.performRequest(api: self, endpoint: "FileMaker_Tables/\(tableName)", method: .delete, responseType: CreationTableField.self)
    }

    /// Delete a column from a table by its name.
    func deleteColumnFromTable(tableName: String, fieldName: String) async throws {
        try webRequestHelper.validateTable(tableName)
        try webRequestHelper.validateField(fieldName)
        _ = try await webRequestHelper.performRequest(api: self, endpoint: "FileMaker_Tables/\(tableName)/\(fieldName)", method: .delete, responseType: CreationTableField.self)
    }

    /// Create an index for a table.
    func createFieldIndex(tableName: String, index: String) async throws {
        try webRequestHelper.validateTable(tableName)
        try webRequestHelper.validateIndex(index)
        _ = try await webRequestHelper.performRequest(api: self, endpoint: "FileMaker_Indexes/\(tableName)", method: .post, responseType: CreationTableField.self)
    }

    /// Delete an index from a table by its name.
    func deleteIndexFromTable(tableName: String, index: String) async throws {
        try webRequestHelper.validateTable(tableName)
        try webRequestHelper.validateIndex(index)
        let result = try await webRequestHelper.performRequest(api: self, endpoint: "FileMaker_Indexes/\(tableName)/\(index)", method: .delete, responseType: CreationTableField.self)
    }
}
