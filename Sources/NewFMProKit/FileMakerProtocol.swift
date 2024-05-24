//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 23/05/24.
//

import Foundation

struct JSONValue <T: Codable>: Codable {
    var value: T
}

/// Enumeration of all the possible filterOption of an OData query
public enum FilterOption: String {
    case equal = "eq"
    case notEqual = "ne"
    case greaterThen = "gt"
    case lessThen = "lt"
    case greaterEqual = "ge"
    case lessEqual = "le"
}

/// Enumeration of all the possible HTTP method of the protocol
public enum HTTPMethod: String {
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
    case post = "POST"
}

// change the documentation
/// Enumeration of all the possible version of the protocol
public enum ProtocolVersion: String {
    case vLatest
    case v1
    case v2
    case v4
}
/// Enumeration of all the possible orderOption of an OData query
public enum Order: String {
    case desc
    case asc
}

protocol FileMakerProtocol {
    var baseURL: URL { get }
    var basicAuthCredentials: (username: String, password: String)? { get set }
    var version: ProtocolVersion { get }
    var database: String { get }

    init(hostname: String, version: ProtocolVersion, database: String)

    func setBasicAuthCredentials(username: String, password: String) 

}
