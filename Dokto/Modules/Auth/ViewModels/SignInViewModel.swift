//
//  SignInViewModel.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class SignInViewModel {

}

//MARK: Request related
extension SignInViewModel {
    
    func signIn(with params: [String: Any], completion: @escaping(LoginResponseDetails?, RMErrorModel?) -> ()) {
        let request = RMRequestModel()
        request.path = Constants.Api.Login.login
        request.body = params
        request.method = .post
        
        RequestManager.request(request: request, type: LoginResponseDetails.self) { response, error in
            if let object = response.first {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
