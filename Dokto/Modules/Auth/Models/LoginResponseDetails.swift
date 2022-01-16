//
//  LoginResponseDetails.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

struct LoginResponseDetails: Codable {
    let message : String?
    let result : LoginResponseResultDetails?
    let statusCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case result
        case statusCode = "status_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        result = try? values?.decodeIfPresent(LoginResponseResultDetails.self, forKey: .result)
        statusCode = try? values?.decodeIfPresent(Int.self, forKey: .statusCode)
    }
}

struct LoginResponseResultDetails: Codable {
    let city : String?
    let contactNo : String?
    let createdAt : String?
    let dateJoined : String?
    let deletedAt : String?
    let email : String?
    let fullName : String?
    let id : String?
    let isActive : Bool?
    let isDeleted : Bool?
    let isStaff : Bool?
    let isSuperuser : Bool?
    let isVerified : Bool?
    let lastLogin : String?
    let profilePhoto : String?
    let state : String?
    let street : String?
    let token : String?
    let updatedAt : String?
    let userType : String?
    let zipCode : String?
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case contactNo = "contact_no"
        case createdAt = "created_at"
        case dateJoined = "date_joined"
        case deletedAt = "deleted_at"
        case email = "email"
        case fullName = "full_name"
        case id = "id"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
        case isStaff = "is_staff"
        case isSuperuser = "is_superuser"
        case isVerified = "is_verified"
        case lastLogin = "last_login"
        case profilePhoto = "profile_photo"
        case state = "state"
        case street = "street"
        case token = "token"
        case updatedAt = "updated_at"
        case userType = "user_type"
        case zipCode = "zip_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        city = try? values?.decodeIfPresent(String.self, forKey: .city)
        contactNo = try? values?.decodeIfPresent(String.self, forKey: .contactNo)
        createdAt = try? values?.decodeIfPresent(String.self, forKey: .createdAt)
        dateJoined = try? values?.decodeIfPresent(String.self, forKey: .dateJoined)
        deletedAt = try? values?.decodeIfPresent(String.self, forKey: .deletedAt)
        email = try? values?.decodeIfPresent(String.self, forKey: .email)
        fullName = try? values?.decodeIfPresent(String.self, forKey: .fullName)
        id = try? values?.decodeIfPresent(String.self, forKey: .id)
        isActive = try? values?.decodeIfPresent(Bool.self, forKey: .isActive)
        isDeleted = try? values?.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isStaff = try? values?.decodeIfPresent(Bool.self, forKey: .isStaff)
        isSuperuser = try? values?.decodeIfPresent(Bool.self, forKey: .isSuperuser)
        isVerified = try? values?.decodeIfPresent(Bool.self, forKey: .isVerified)
        lastLogin = try? values?.decodeIfPresent(String.self, forKey: .lastLogin)
        profilePhoto = try? values?.decodeIfPresent(String.self, forKey: .profilePhoto)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
        street = try? values?.decodeIfPresent(String.self, forKey: .street)
        token = try? values?.decodeIfPresent(String.self, forKey: .token)
        updatedAt = try? values?.decodeIfPresent(String.self, forKey: .updatedAt)
        userType = try? values?.decodeIfPresent(String.self, forKey: .userType)
        zipCode = try? values?.decodeIfPresent(String.self, forKey: .zipCode)
    }
}
