//
//  ClinicRegistrationViewModel.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 30/11/21.
//

import UIKit

class ClinicRegistrationViewModel{
    
}

//Request
extension ClinicRegistrationViewModel{
    func registerClinic(with params : [String : Any],completion : @escaping(ClinicRegistrationResponse?,RMErrorModel?)-> ()){
        
                let request = RMRequestModel()
                request.path = Constants.Api.Auth.Clinic.registration
                request.body = params
                request.method = .post
        
                print(request.body)
        
                RequestManager.request(request: request, type: ClinicRegistrationResponse.self) { response, error in
                    print(response)
                    if let object = response.first {
                        completion(object,nil)
                    }
                    else{
                        completion(nil,error)
                    }
                }
    
    }
    
}
