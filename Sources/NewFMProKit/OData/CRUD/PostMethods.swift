//
//  File.swift
//
//
//  Created by Adriano d'Alessandro on 24/05/24.
//

import Foundation

struct EmptyResponse: Codable {}


@available(iOS 13.0.0, *)
@available(macOS 13.0, *)
extension FMOdataApi {
    
    func createRecord<T: Codable>(table: CustomStringConvertible, data: T) async throws -> T{
        guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        return try await webRequestHelper.performRequest(api: self, endpoint: table, method: .post, responseType: T.self, data: data)
    }
    
    /// Delete the record inside a specific table using its id
    /// - Parameters:
    ///   - table: The name of the table in which to perform the action
    ///   - id: The Primary key (PK) of the searched record
    /// - Throws:
    ///   - FMProErrors.tableNameMissing: If the table name is empty
    func deleteRecord(table: CustomStringConvertible, id: CustomStringConvertible) async throws -> Bool {
        guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        return try await webRequestHelper.performRequest(api: self, endpoint: "\(table.description)('\(id.description)')", method: .delete, responseType: Bool.self)
    }
    
    /// Delete all the records inside a specific table matching a query
    /// - Parameters:
    ///   - table: The name of the table in which to perform the action
    ///   - query: An OData query used to filter the API call
    /// - Throws:
    ///   - FMProErrors.tableNameMissing: If the table name is empty
    func deleteRecordUsingQuery(table: CustomStringConvertible, query: CustomStringConvertible) async throws -> Bool {
        guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        return try await webRequestHelper.performRequest(api: self, endpoint: "\(table.description)?\(query.description)", method: .delete, responseType: Bool.self)
        }
    
    /// Delete all the records inside a specific table matching a filter query
    /// - Parameters:
    ///   - table: The name of the table in which to perform the action
    ///   - field: The field used to filter the table
    ///   - filterOption: The filter option for the query
    ///   - value: The value of the field that needs to match in the query
    /// - Throws:
    ///   - FMProErrors.tableNameMissing: If the table name is empty
    func deleteRecord<T>(table: CustomStringConvertible, field: CustomStringConvertible, filterOption: FilterOption, value: T) async throws -> Bool {
        guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        return try await webRequestHelper.performRequest(api: self, endpoint: "\(table)?$filter=\(field) \(filterOption.rawValue) \(value is String ? "'\(value)'" : "\(value)")", method: .delete, responseType: Bool.self)
    }
    
    func editRecord<T: Codable>(table: CustomStringConvertible, endPoint: CustomStringConvertible, filterField: CustomStringConvertible? = nil, filterOption: FilterOption? = nil, data: T) async throws -> T {
        guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        var endpoint: CustomStringConvertible = endPoint
        if let id = endPoint as? String {
            endpoint = "\(table)('\(id)')"
        } else if let id = endPoint as? UUID {
            endpoint = "\(table)('\(id.uuidString)')"
        } else if let id = endPoint as? Int {
            endpoint = "\(table)('\(id)')"
        } else if let query = endPoint as? String {
            endpoint = "\(table)?\(query)"
        } else {
            throw FMProErrors.invalidIdentifier
        }
        if let filterField = filterField, let filterOption = filterOption {
            guard !filterField.description.isEmpty else {
                throw FMProErrors.fieldNameMissing
            }
            endpoint = endpoint.description + "(\(filterField) \(filterOption.rawValue))"
        }
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .patch, responseType: T.self, data: data)
    }
}
