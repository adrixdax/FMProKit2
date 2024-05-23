import Foundation

@available(iOS 13.0.0, *)
@available(macOS 12.0, *)
class FMOdataApi: FileMakerProtocol {
    let baseURL: URL
    var basicAuthCredentials: (username: String, password: String)?
    let baseUri: String
    let version: ProtocolVersion
    let database: String

    required init(hostname: String, version: ProtocolVersion, database: String) {
        self.version = version
        self.database = database
        self.baseUri = "https://\(hostname)/fmi/odata/\(version.rawValue)/\(database)"
        self.baseURL = URL(string: self.baseUri)!
    }

    func setBasicAuthCredentials(username: String, password: String) {
        basicAuthCredentials = (username, password)
    }
}
