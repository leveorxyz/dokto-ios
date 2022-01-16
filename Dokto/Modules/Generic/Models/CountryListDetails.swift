//
//  CountryListDetails.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 30/11/21.
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
    let name : String?
    let countryCode : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case countryCode = "country_code"
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        name = try? values?.decodeIfPresent(String.self, forKey: .name)
        countryCode = try? values?.decodeIfPresent(String.self, forKey: .countryCode)
    }
}
