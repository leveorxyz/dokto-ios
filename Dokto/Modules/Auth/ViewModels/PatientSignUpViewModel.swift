//
//  PatientSignUpViewModel.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class PatientSignUpViewModel {
    
}

//MARK: Request related methods
extension PatientSignUpViewModel {
    
    func signUp(with headers: [String:String], completion: @escaping(SignUpResponseDetails?, RMErrorModel?) -> ()) {
        let request = RMRequestModel()
        request.path = Constants.Api.Auth.Patient.registration
        request.headers = headers
        request.method = .post
        if let object = DataManager.shared.patientSignUpRequestDetails?.asDictionary() {
            request.body = object
        }
        
        RequestManager.request(request: request, type: SignUpResponseDetails.self) { response, error in
            if let object = response.first {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
