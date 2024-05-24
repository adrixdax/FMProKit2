import XCTest
@testable import NewFMProKit

import Foundation

enum Status: Int, Identifiable, CaseIterable, Codable {
    /// Student status.
    case student = 1
    /// Alumnus status.
    case alumnus = 2
    /// Manager status.
    case manager = 3
    /// Pier status.
    case pier = 4
    /// Mentor status.
    case mentor = 5

    /// The raw value of the status.
    var id: Int {
        rawValue
    }
    
    /// A human-readable display name for the status.
    var displayName: String {
        switch self {
        case .student:
            return "Student"
        case .alumnus:
            return "Alumnus"
        case .manager:
            return "Manager"
        case .pier:
            return "Pier"
        case .mentor:
            return "Mentor"
        }
    }
    
    /// Coding keys for the enumeration.
    enum CodingKeys: String, CodingKey {
        case student
        case alumnus
        case manager
        case pier
        case mentor
    }
    
    /// Initializes an enumeration case from decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        guard let status = Status(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid Status raw value: \(rawValue)"
            )
        }
        self = status
    }

    /// Encodes the enumeration case to encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .student:
            try container.encode(self.rawValue, forKey: .student)
        case .alumnus:
            try container.encode(self.rawValue, forKey: .alumnus)
        case .manager:
            try container.encode(self.rawValue, forKey: .manager)
        case .pier:
            try container.encode(self.rawValue, forKey: .pier)
        case .mentor:
            try container.encode(self.rawValue, forKey: .mentor)
        }
    }
}


/// A model representing a person with DB attributes.
class Person: Identifiable, ObservableObject, Codable, Equatable {
    
    /// The unique identifier for the person (DB & SwiftData).
    var personID: String
    
    /// The first name of the person.
    var firstName: String
    
    /// The middle name of the person (optional).
    var middleName: String?
    
    /// The surname of the person (optional).
    var surname: String?
    
    /// The contact email of the person (optional).
    var contactEmail: String?
    
    /// The creation date of the person's record (optional).
    var creationDate: Date?
    
    /// The date of birth of the person (optional).
    var dateOfBirth: Date?
    
    /// The home academy of the person (optional).
    var homeAcademy: String?
    
    /// The current location of the person (optional).
    var location: String?
    
    /// The nationality of the person (optional).
    var nationality: String?
    
    /// The profile picture of the person, stored as Data (optional).
    var profilePicture: Data?
    
    /// The integer representation of the person's status (optional).
    var statusId: Int?
    
    /// The status of the person, derived from `statusId`.
    var status: Status {
        Status(rawValue: statusId!)!
    }
    
    /// Coding keys to map the `Person` properties to JSON keys.
    enum CodingKeys: String, CodingKey {
        case personID
        case firstName
        case middleName
        case surname
        case contactEmail
        case creationDate
        case dateOfBirth
        case homeAcademy
        case location
        case nationality
        case profilePicture
        case statusId
    }
    
    /// Initializes a new instance of `Person`.
    ///
    /// - Parameters:
    ///   - personID: The unique identifier for the person.
    ///   - firstName: The first name of the person.
    ///   - middleName: The middle name of the person (optional).
    ///   - surname: The surname of the person (optional).
    ///   - contactEmail: The contact email of the person (optional).
    ///   - creationDate: The creation date of the person's record (optional).
    ///   - dateOfBirth: The date of birth of the person (optional).
    ///   - homeAcademy: The home academy of the person (optional).
    ///   - location: The current location of the person (optional).
    ///   - nationality: The nationality of the person (optional).
    ///   - profilePicture: The profile picture of the person, stored as Data (optional).
    ///   - statusId: The integer representation of the person's status (optional).
    init(personID: String, firstName: String, middleName: String? = nil, surname: String? = nil, contactEmail: String? = nil, creationDate: Date? = nil, dateOfBirth: Date? = nil, homeAcademy: String? = nil, location: String? = nil, nationality: String? = nil, profilePicture: Data? = nil, statusId: Int? = nil) {
        self.personID = personID
        self.firstName = firstName
        self.middleName = middleName
        self.surname = surname
        self.contactEmail = contactEmail
        self.creationDate = creationDate
        self.dateOfBirth = dateOfBirth
        self.homeAcademy = homeAcademy
        self.location = location
        self.nationality = nationality
        self.profilePicture = profilePicture
        self.statusId = statusId
    }
    
    /// Initializes a new instance of `Person` from a decoder.
    ///
    /// - Parameter decoder: The decoder to decode data from.
    /// - Throws: An error if decoding fails.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.personID = try container.decode(String.self, forKey: .personID)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.middleName = try container.decodeIfPresent(String.self, forKey: .middleName)
        self.surname = try container.decodeIfPresent(String.self, forKey: .surname)
        self.contactEmail = try container.decodeIfPresent(String.self, forKey: .contactEmail)
        self.creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate)
        self.dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        self.homeAcademy = try container.decodeIfPresent(String.self, forKey: .homeAcademy)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.nationality = try container.decodeIfPresent(String.self, forKey: .nationality)
        self.profilePicture = try container.decodeIfPresent(Data.self, forKey: .profilePicture)
        self.statusId = try container.decodeIfPresent(Int.self, forKey: .statusId)
    }
    
    /// Encodes the `Person` instance into an encoder.
    ///
    /// - Parameter encoder: The encoder to encode data into.
    /// - Throws: An error if encoding fails.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.personID, forKey: .personID)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.middleName, forKey: .middleName)
        try container.encodeIfPresent(self.surname, forKey: .surname)
        try container.encodeIfPresent(self.contactEmail, forKey: .contactEmail)
        try container.encodeIfPresent(self.creationDate, forKey: .creationDate)
        try container.encodeIfPresent(self.dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(self.homeAcademy, forKey: .homeAcademy)
        try container.encodeIfPresent(self.location, forKey: .location)
        try container.encodeIfPresent(self.nationality, forKey: .nationality)
        try container.encodeIfPresent(self.profilePicture, forKey: .profilePicture)
        try container.encodeIfPresent(self.statusId, forKey: .statusId)
    }
    
    /// A description of the person, combining the first name, middle name, and surname.
    var description: String {
        return (self.firstName + " " + ((self.middleName != nil ? self.middleName! + " " : "") + ((self.surname != nil ? self.surname : " ")!)))
    }
    
    /// Compares two `Person` instances for equality based on their `personID`.
    ///
    /// - Parameters:
    ///   - lhs: The first `Person` instance.
    ///   - rhs: The second `Person` instance.
    /// - Returns: `true` if both instances have the same `personID`, otherwise `false`.
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.personID == rhs.personID
    }
}


final class NewFMProKitTests: XCTestCase {
    func testExample() async throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        var api = FMOdataApi(hostname: "napoli-2.fm-testing.com:443", version: .v4, database: "SevenSeasDevelopment")
        api.setBasicAuthCredentials(username: "rest", password: "Minyma97!")
        let people = try await api.getTable("Person", to: [Person].self)
        let me = try await api.getRecord(table: "Person", id: "B1C30563-2232-422E-946D-2D3DFE5CFE74", to: Person.self)
    }
}
