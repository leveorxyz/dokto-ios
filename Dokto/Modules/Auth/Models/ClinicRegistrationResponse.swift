//
//  ClinicRegistrationResponse.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 30/11/21.
//

import Foundation

struct ClinicRegistrationResponse: Codable {
    let message: String
    let statusCode: Int
    let result: Result

    enum CodingKeys: String, CodingKey {
        case message
        case statusCode
        case result
    }
}


struct Result: Codable {
    let lastLogin: JSONNull?
    let zipCode, state, id, email: String
    let fullName, city, contactNo, street: String
    let numberOfPractitioners: Int
    let username, token: String
    let profilePhoto: String

    enum CodingKeys: String, CodingKey {
        case lastLogin
        case zipCode
        case state, id, email
        case fullName
        case city
        case contactNo
        case street
        case numberOfPractitioners
        case username, token
        case profilePhoto
    }
}



class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}




