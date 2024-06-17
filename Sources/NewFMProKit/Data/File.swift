//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 17/06/24.
//

import Foundation

class TokenModel: Codable {
    var token: String?
}

class Token: Codable {
    var response: TokenModel?
}


@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
public class FMDataApi: FileMakerProtocol {
    /// The base URL for the OData API
    let baseURL: URL
    /// The username and password for basic authentication
    var basicAuthCredentials: (username: String, password: String)?
    /// The protocol version for the OData API
    let version: ProtocolVersion
    /// The name of the database to interact with
    let database: String
    /// The bearer token used for authorization
    var bearerToken: String
    /// The URL request for making API calls
    var request: URLRequest
    /// The JSON response from the API
    var responseJSON = Data()

    /// The class initializer used to setup all the information used to access and interface the Filemaker Database using OData.
    /// - Parameters:
    ///   - hostname: the URL of the Filemaker Database passed as a String
    ///   - version: the protocol version for the OData API
    ///   - database: the Database name of the Filemaker Database passed as a String
    public required init(hostname: String, version: ProtocolVersion, database: String) {
        self.version = version
        self.database = database
        self.baseURL = URL(string: "https://\(hostname)/fmi/odata/\(version.rawValue)/\(database)/")!
        self.bearerToken = ""
        self.request = URLRequest(url: self.baseURL)
    }

    /// Set the basic authentication credentials
    /// - Parameters:
    ///   - username: The username for basic authentication
    ///   - password: The password for basic authentication
    public func setBasicAuthCredentials(username: String, password: String) {
        basicAuthCredentials = (username, password)
        guard let basicAuth = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
            return
        }
        self.request.setValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
    }

    /// Fetch the bearer token for authorization
    /// - Throws: An error if the token cannot be fetched
    public func fetchToken() async throws {
        let tokenEndpoint = "https://\(baseURL.host!)/fmi/data/vLatest/databases/\(database)/sessions"
        guard let tokenRequestURL = URL(string: tokenEndpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            throw URLError(.badURL)
        }

        guard let basicAuth = (basicAuthCredentials!.username + ":" + basicAuthCredentials!.password).data(using: .utf8)?.base64EncodedString() else {
            throw AuthError.authorizationEncodingError
        }

        var tokenRequest = URLRequest(url: tokenRequestURL)
        tokenRequest.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
        tokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        tokenRequest.httpMethod = "POST"

        let (data, response) = try await URLSession.shared.data(for: tokenRequest)

        guard (response as? HTTPURLResponse)?.statusCode != 401 else {
            throw FetchError.tokenRequestError
        }

        let fetchedData = try JSONDecoder().decode(Token.self, from: data)

        self.bearerToken = "Bearer \(fetchedData.response?.token ?? "")"
    }

    /// Update the username and password for basic authentication and fetch a new token
    /// - Parameters:
    ///   - username: The new username
    ///   - password: The new password
    /// - Throws: An error if the token cannot be fetched
    public func updateUsernameAndPassword(username: String, password: String) async throws {
        self.basicAuthCredentials = (username, password)
        try await fetchToken()
    }
}
