//
//  CountryListDetails.swift
//  Dokto
//
//  Created by Rupak on 11/27/21.
//

import UIKit

struct CountryListDetails: Codable {
    let message : String?
    let result : [CountryListItemDetails]?
    let statusCode : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case result = "result"
        case statusCode = "status_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        result = try? values?.decodeIfPresent([CountryListItemDetails].self, forKey: .result)
        statusCode = try? values?.decodeIfPresent(Int.self, forKey: .statusCode)
    }
}

struct CountryListItemDetails: Codable {
    let countryCode : String?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case name = "name"
    }
    init(code: String, name: String) {
        self.countryCode = code
        self.name = name
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        countryCode = try? values?.decodeIfPresent(String.self, forKey: .countryCode)
        name = try? values?.decodeIfPresent(String.self, forKey: .name)
    }
}
