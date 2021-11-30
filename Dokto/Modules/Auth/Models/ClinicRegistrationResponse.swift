//
//  ClinicRegistrationResponse.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 30/11/21.
//

import Foundation

struct ClinicRegistrationResponse: Codable {
    let message : String?
    let result : RegistrationResult?
    let statusCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case result = "result"
        case statusCode = "status_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        result = try? values?.decodeIfPresent(RegistrationResult.self, forKey: .result)
        statusCode = try? values?.decodeIfPresent(Int.self, forKey: .statusCode)
    }
}

struct RegistrationResult: Codable {
    let name : String?
    let city : String?
    let street : String?
    let state : String?
    let zipCode : String?
    let contactNumber : String?
    let email : String?
    let id : String?
    let username : String?
    let numberOfParticipants : Int?
    let token : String?
    let profilePhoto : String?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case city = "city"
        case street = "street"
        case state = "state"
        case zipCode = "zip_code"
        case contactNumber = "contact_no"
        case email = "email"
        case id = "id"
        case username = "username"
        case numberOfParticipants = "number_of_practitioners"
        case token = "token"
        case profilePhoto = "profile_photo"
//        city": "Ghazni",
//        "full_name": "L hospital",
//        "street": "afghan road",
//        "state": "Ghazni",
//        "zip_code": "1400",
//        "contact_no": "931111111",
//        "email": "newEmailForJason1163@gmail.com",
//        "id": "c739b88f-ffa9-4e03-9a5f-f9064b472b65",
//        "last_login": null,
//        "username": "l.hospital.1",
//        "number_of_practitioners": 2,
//        "token": "da6a301a7d35cacd301b3a030871b1659c4477f8",
//        "profile_photo": "https://doktoapi.toybethdev.net/media/profile_photo/c739b88f-ffa9-4e03-9a5f-f9064b472b65_2021_11_30_11_39_51_134799.jpeg"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        name = try? values?.decodeIfPresent(String.self, forKey: .name)
        city = try? values?.decodeIfPresent(String.self, forKey: .city)
        street = try? values?.decodeIfPresent(String.self, forKey: .street)
        state  = try? values?.decodeIfPresent(String.self, forKey: .state)
        zipCode = try? values?.decodeIfPresent(String.self, forKey: .zipCode)
        contactNumber = try? values?.decodeIfPresent(String.self, forKey: .contactNumber)
        email = try? values?.decodeIfPresent(String.self, forKey: .email)
        id = try? values?.decodeIfPresent(String.self, forKey: .id)
        username = try? values?.decodeIfPresent(String.self, forKey: .email)
        numberOfParticipants = try? values?.decodeIfPresent(Int.self, forKey: .numberOfParticipants)
        token = try? values?.decodeIfPresent(String.self, forKey: .token)
        profilePhoto = try? values?.decodeIfPresent(String.self, forKey: .profilePhoto)
    }
}



