//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 17/06/24.
//

import Foundation

/// Represents a script caller with a generic parameter.
struct ScriptCaller<T: Codable>: Codable {
    let scriptParameterValue: T
}

/// Represents the result of a script execution.
struct ScriptResult: Codable {
    let code: Int?
    let resultParameter: String?
    let message: String?
}

/// Represents a scripter containing a script result.
struct Scripter: Codable {
    let scriptResult: ScriptResult
}
