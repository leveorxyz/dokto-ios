//
//  PaymentResponseDetails.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

struct PaymentResponseDetails: Codable {
    let status_code : Int
    let message : String
    let result : [String : String]
}
