//
//  RMErrorModel.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

enum RMErrorKey: String {
    case general = "Error_general"
    case parsing = "Error_parsing"
}

class RMErrorModel: Error, Codable {
    
    let error : String?
    let status: Int?
    let flag : Int?
    var messageKey: String?
    var message: String {
        return error ?? messageKey ?? ""
    }
    
    init(_ messageKey: String) {
        self.messageKey = messageKey
        self.error = nil
        self.flag = nil
        self.status = nil
    }
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case flag = "flag"
        case messageKey = "message"
        case status = "status"
    }
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        error = try? values?.decodeIfPresent(String.self, forKey: .error)
        flag = try? values?.decodeIfPresent(Int.self, forKey: .flag)
        messageKey = try? values?.decodeIfPresent(String.self, forKey: .messageKey)
        status = try? values?.decodeIfPresent(Int.self, forKey: .status)
    }
}

//MARK: - Public Functions
extension RMErrorModel {
    
    class func generalError() -> RMErrorModel {
        return RMErrorModel(RMErrorKey.general.rawValue)
    }
}
