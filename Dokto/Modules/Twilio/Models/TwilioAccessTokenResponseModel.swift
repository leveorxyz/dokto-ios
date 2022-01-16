//
//  TwilioAccessTokenResponseModel.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import Foundation

struct TwilioVideoTokenAPIResponse : Codable{
    let status_code : Int
    let message : String
    let result : TwilioTokenMessage
}

struct TwilioTokenMessage : Codable{
    let token : String
}
