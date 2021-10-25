//
//  TwilioViewModel.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import UIKit

class TwilioViewModel{
    let twilioManager = TwilioManager()
    
    //Access token from Backend
    func getTwilioAccessToken(userName : String ,roomName : String,completion : @escaping (String)-> Void){
        let data : [String : Any] = [
            "username" : userName,
            "room_name" : roomName
        ]
        twilioManager.getAccessToken(urlPath: Constants.Api.Twilio.twilioTokenUrl, body: data) { result in
            switch result{
                
            case .success(let tokenResponse):
                let token = tokenResponse.result.token
                //print(token)
                completion(token)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}
