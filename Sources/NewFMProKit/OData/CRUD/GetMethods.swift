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
    
    /// Fetches records from a specific table with optional filtering, ordering, and limits on number of records.
    /// - Parameters:
    ///   - table: The name of the table in which to perform the action
    ///   - filterField: The field used to filter the table (optional)
    ///   - filterOption: The filter option for the query (optional)
    ///   - value: The value of the field that needs to match in the query (optional)
    ///   - orderField: The name of the field to order by (optional)
    ///   - order: The order in which the field will be returned (optional)
    ///   - top: The maximum number of records to fetch (optional)
    ///   - skip: The number of records to skip (optional)
    ///   - type: The type to decode the records into
    /// - Returns: An array of the generic type used to decode the records
    /// - Throws: Various errors based on the query and table parameters
    func getTable<T: Codable>(
            table: CustomStringConvertible,
            filterField: CustomStringConvertible? = nil,
            filterOption: FilterOption? = nil,
            value: CustomStringConvertible? = nil,
            orderField: CustomStringConvertible? = nil,
            order: Order? = nil,
            top: Int? = nil,
            skip: Int? = nil,
            to type: T.Type
        ) async throws -> T {
            guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        if let top = top, top < 0 {
            throw FMProErrors.negativeNumber
        }
        if let skip = skip, skip < 0 {
            throw FMProErrors.negativeNumber
        }        
        var queryItems: [String] = []
        if let field = filterField, let filterOption = filterOption, let value = value {
            let valueString = value is String ? "'\(value)'" : "\(value)"
            queryItems.append("$filter=\(field) \(filterOption.rawValue) \(valueString)")
        }
        // Add order query if fieldName and order are provided
        if let fieldName = orderField, let order = order {
            queryItems.append("$orderby=\(fieldName) \(order.rawValue)")
        }
        // Add top query if top is provided
        if let top = top {
            queryItems.append("$top=\(top)")
        }
        // Add skip query if skip is provided
        if let skip = skip {
            queryItems.append("$skip=\(skip)")
        }
            let query = queryItems.isEmpty ? "" : "?".appending(queryItems.joined(separator: "&"))
            return try await webRequestHelper.performRequest(api: self, endpoint: "\(table)\(query)", method: .get, responseType: T.self)
    }
    
    /// Fetches a record from a specific table by ID and decodes it to the specified type.
    /// - Parameters:
    ///   - table: The name of the table.
    ///   - id: The ID of the record, which can be of type `String`, `UUID`, or any `Numeric`.
    ///   - type: The type to decode the record to.
    /// - Returns: The decoded record of the specified type.
    func getRecord<T: Codable, U: CustomStringConvertible>(table: CustomStringConvertible, id: U, to type: T.Type) async throws -> T {
        return try await webRequestHelper.performRequest(api: self, endpoint: ("\(table)('\(id is String ? "\(id)" : String(describing: id))')").description,method: .get, responseType: T.self)
    }
    
    /// Retrieves the value of a field of a specific record as binary data.
    /// - Parameters:
    ///   - table: The name of the table in which to perform the action.
    ///   - id: The ID (primary key) of the searched record.
    ///   - field: The name of the field.
    /// - Returns: The value of the specified field as binary data.
    /// - Throws: An error if the table name or field name is missing, or if the record ID doesn't exist.
    func getDataField(table: CustomStringConvertible, id: CustomStringConvertible, field: CustomStringConvertible) async throws -> Data {
        guard !table.description.isEmpty else {
            throw FMProErrors.tableNameMissing
        }
        guard !field.description.isEmpty else {
            throw FMProErrors.fieldNameMissing
        }
        return try await webRequestHelper.performRequest(api: self, endpoint: ("\(table)('\(String(describing: id))')/\(field)/$value").description,method: .get, responseType: Data.self)
    }
    
    func getTopTable<T: Codable>(table: String, number: Int) async throws -> [T] {
        try webRequestHelper.validateTable(table)
        try webRequestHelper.validateNumber(number)
        let endpoint = "\(table)?$top=\(number)"
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .get, responseType: [T].self)
    }

    func getSkipTable<T: Codable>(table: String, number: Int) async throws -> [T] {
        try webRequestHelper.validateTable(table)
        try webRequestHelper.validateNumber(number)
        let endpoint = "\(table)?$skip=\(number)"
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .get, responseType: [T].self)
    }
    
    func getTableCount(table: String) async throws -> Int {
        try webRequestHelper.validateTable(table)
        let endpoint = "\(table)/$count"
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .get, responseType: Int.self)
    }

    func getField<T: Codable>(table: String, id: CustomStringConvertible, field: String) async throws -> T {
        try webRequestHelper.validateTable(table)
        try webRequestHelper.validateField(field)
        let endpoint = "\(table)('\(id)')/\(field)"
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: .get, responseType: T.self)
    }

}
