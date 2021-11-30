//
//  DoctorSignUpResponseDetails.swift
//  Dokto
//
//  Created by Rupak on 11/30/21.
//

import UIKit

struct DoctorSignUpResponseDetails: Codable {
    let message : String?
    let result : DoctorSignUpResponseResultDetails?
    let statusCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case result
        case statusCode = "status_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        result = try? values?.decodeIfPresent(DoctorSignUpResponseResultDetails.self, forKey: .result)
        statusCode = try? values?.decodeIfPresent(Int.self, forKey: .statusCode)
    }
}

struct DoctorSignUpResponseResultDetails: Codable {
    let city : String?
    let contactNo : String?
    let email : String?
    let fullName : String?
    let id : String?
    let lastLogin : String?
    let profilePhoto : String?
    let state : String?
    let street : String?
    let token : String?
    let username : String?
    let zipCode : String?
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case contactNo = "contact_no"
        case email = "email"
        case fullName = "full_name"
        case id = "id"
        case lastLogin = "last_login"
        case profilePhoto = "profile_photo"
        case state = "state"
        case street = "street"
        case token = "token"
        case username = "username"
        case zipCode = "zip_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        city = try? values?.decodeIfPresent(String.self, forKey: .city)
        contactNo = try? values?.decodeIfPresent(String.self, forKey: .contactNo)
        email = try? values?.decodeIfPresent(String.self, forKey: .email)
        fullName = try? values?.decodeIfPresent(String.self, forKey: .fullName)
        id = try? values?.decodeIfPresent(String.self, forKey: .id)
        lastLogin = try? values?.decodeIfPresent(String.self, forKey: .lastLogin)
        profilePhoto = try? values?.decodeIfPresent(String.self, forKey: .profilePhoto)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
        street = try? values?.decodeIfPresent(String.self, forKey: .street)
        token = try? values?.decodeIfPresent(String.self, forKey: .token)
        username = try? values?.decodeIfPresent(String.self, forKey: .username)
        zipCode = try? values?.decodeIfPresent(String.self, forKey: .zipCode)
    }
}
