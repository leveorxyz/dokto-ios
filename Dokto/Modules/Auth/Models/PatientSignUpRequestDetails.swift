//
//  PatientSignUpRequestDetails.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

struct PatientSignUpRequestDetails: Codable {
    var city : String?
    var contactNo : String?
    var dateOfBirth : String?
    var email : String?
    var fullName : String?
    var gender : String?
    var identificationNumber : String?
    var identificationPhoto : String?
    var identificationType : String?
    var insuranceType : String?
    var password : String?
    var profilePhoto : String?
    var socialSecurityNumber : String?
    var state : String?
    var street : String?
    var zipCode : String?
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case contactNo = "contact_no"
        case dateOfBirth = "date_of_birth"
        case email = "email"
        case fullName = "full_name"
        case gender = "gender"
        case identificationNumber = "identification_number"
        case identificationPhoto = "identification_photo"
        case identificationType = "identification_type"
        case insuranceType = "insurance_type"
        case password = "password"
        case profilePhoto = "profile_photo"
        case socialSecurityNumber = "social_security_number"
        case state = "state"
        case street = "street"
        case zipCode = "zip_code"
    }
    init() {}
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        city = try? values?.decodeIfPresent(String.self, forKey: .city)
        contactNo = try? values?.decodeIfPresent(String.self, forKey: .contactNo)
        dateOfBirth = try? values?.decodeIfPresent(String.self, forKey: .dateOfBirth)
        email = try? values?.decodeIfPresent(String.self, forKey: .email)
        fullName = try? values?.decodeIfPresent(String.self, forKey: .fullName)
        gender = try? values?.decodeIfPresent(String.self, forKey: .gender)
        identificationNumber = try? values?.decodeIfPresent(String.self, forKey: .identificationNumber)
        identificationPhoto = try? values?.decodeIfPresent(String.self, forKey: .identificationPhoto)
        identificationType = try? values?.decodeIfPresent(String.self, forKey: .identificationType)
        insuranceType = try? values?.decodeIfPresent(String.self, forKey: .insuranceType)
        password = try? values?.decodeIfPresent(String.self, forKey: .password)
        profilePhoto = try? values?.decodeIfPresent(String.self, forKey: .profilePhoto)
        socialSecurityNumber = try? values?.decodeIfPresent(String.self, forKey: .socialSecurityNumber)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
        street = try? values?.decodeIfPresent(String.self, forKey: .street)
        zipCode = try? values?.decodeIfPresent(String.self, forKey: .zipCode)
    }
}
