//
//  GenericViewModel.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class GenericViewModel {

}

//MARK: Request related
extension GenericViewModel {
    
    func getCountryCodeList(completion: @escaping(CountryCodeListDetails?, RMErrorModel?) -> ()) {
        let request = RMRequestModel()
        request.path = Constants.Api.Generic.countryCode
        request.method = .get
        
        RequestManager.request(request: request, type: CountryCodeListDetails.self) { response, error in
            if let object = response.first {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getCountryList(completion: @escaping(CountryListDetails?,RMErrorModel?)->()){
        let request = RMRequestModel()
        request.path = Constants.Api.Generic.countryList
        request.method = .get
        
        RequestManager.request(request: request, type: CountryListDetails.self) { response, error in
            if let object = response.first {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    func getStateList(params: [String:Any], completion: @escaping(StateListDetails?, RMErrorModel?) -> ()) {
        let request = RMRequestModel()
        request.path = Constants.Api.Generic.stateList
        request.parameters = params
        request.method = .get
        
        RequestManager.request(request: request, type: StateListDetails.self) { response, error in
            if let object = response.first {
                completion(object, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
