//
//  RMResponseModel.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

struct RMResponseModel<T: Codable>: Codable {
    
    var statusCode: Int
    var message: String
    var error: RMErrorModel {
        set {}
        get {
            return RMErrorModel(message)
        }
    }
    var rawData: Data?
    var data: [T]?
    var json: String? {
        guard let rawData = rawData else { return nil }
        return String(data: rawData, encoding: String.Encoding.utf8)
    }
    var request: RMRequestModel?
    
    public init(from decoder: Decoder) throws {
        let keyedContainer = try? decoder.container(keyedBy: CodingKeys.self)
        
        statusCode = (try? keyedContainer?.decodeIfPresent(Int.self, forKey: CodingKeys.statusCode)) ?? 0
        message = (try? keyedContainer?.decodeIfPresent(String.self, forKey: CodingKeys.message)) ?? ""
        if let object = try? T(from: decoder), object.asDictionary()?.count ?? 0 > 0 {
            data = [object]
        } else if let objects = try? keyedContainer?.decodeIfPresent([T].self, forKey: CodingKeys.data), objects.count > 0 {
            data = objects
        } else if let object = try? keyedContainer?.decodeIfPresent(T.self, forKey: CodingKeys.data), object.asDictionary()?.count ?? 0 > 0 {
            data = [object]
        }
    }
}

// MARK: - Private Functions
extension RMResponseModel {
    
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}
