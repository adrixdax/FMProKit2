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
    /*
    func runScript<T: Codable>(scriptName: String, scriptParameterValue: T?) async throws -> ScriptResult {
        let endpoint = "\(baseURL)/Script.\(scriptName)"
        // Determine the responseType based on whether scriptParameterValue is provided
        let responseType: Any.Type = scriptParameterValue != nil ? Scripter.self : ScriptResult.self
        let responseData: Any
        if let parameter = scriptParameterValue {
            responseData = try await performRequest(endpoint, method: .post, responseType: Scripter.self, data: ScriptCaller(scriptParameterValue: parameter))
        } else {
            responseData = try await performRequest(endpoint, method: .post, responseType: ScriptResult.self)
        }
        if let scripterResponse = responseData as? Scripter {
            return scripterResponse.scriptResult
        } else if let scriptResultResponse = responseData as? ScriptResult {
            return scriptResultResponse
        } else {
            throw FMProErrors.invalidResponse
        }
    }
     */
}
