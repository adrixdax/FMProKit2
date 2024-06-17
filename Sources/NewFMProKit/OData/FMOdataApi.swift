import Foundation

@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
class FMOdataApi: FileMakerProtocol {
    let baseURL: URL
    var basicAuthCredentials: (username: String, password: String)?
    let version: ProtocolVersion
    let database: String
    let webRequestHelper = WebRequest()

    required init(hostname: String, version: ProtocolVersion, database: String) {
        self.version = version
        self.database = database
        self.baseURL = URL(string: "https://\(hostname)/fmi/odata/\(version.rawValue)/\(database)/")!
    }

    func setBasicAuthCredentials(username: String, password: String) {
        basicAuthCredentials = (username, password)
    }
    
    @discardableResult
    public func performRequest<T: Codable>(_ endpoint: CustomStringConvertible, method: HTTPMethod, responseType: T.Type, data: T? = nil) async throws -> T {
        return try await webRequestHelper.performRequest(api: self, endpoint: endpoint, method: method, responseType: responseType, data: data)
    }
}
