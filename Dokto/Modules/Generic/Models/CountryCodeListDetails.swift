//
//  CountryCodeListDetails.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

struct CountryCodeListDetails: Codable {
    let message : String?
    let result : [CountryCodeListItemDetails]?
    let statusCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case result = "result"
        case statusCode = "status_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        result = try? values?.decodeIfPresent([CountryCodeListItemDetails].self, forKey: .result)
        statusCode = try? values?.decodeIfPresent(Int.self, forKey: .statusCode)
    }
}

struct CountryCodeListItemDetails: Codable {
    let name : String?
    let phoneCode : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case phoneCode = "phone_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        name = try? values?.decodeIfPresent(String.self, forKey: .name)
        phoneCode = try? values?.decodeIfPresent(String.self, forKey: .phoneCode)
    }
}
