//
//  RequestManager.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

class RequestManager {}

// MARK: - Public Functions
extension RequestManager {
    
    static func request<T: Codable>(request: RMRequestModel, type: T.Type, completion: @escaping(_ response: [T],_ error: RMErrorModel?) -> Void) {
        
        URLSession.shared.dataTask(with: request.urlRequest()) { data, response, error in
            
            // try to parse into model
            guard let rawData = data, var responseModel = try? JSONDecoder().decode(RMResponseModel<T>.self, from: rawData) else {
                let error: RMErrorModel = RMErrorModel(RMErrorKey.parsing.rawValue)
                completion([], error)
                print(error.localizedDescription)
                return
            }
            
            //try to parse error object
            if responseModel.data == nil, let data = data, let errorObject = try? JSONDecoder().decode(RMErrorModel.self, from: data) {
                completion([], errorObject)
                return
            }
            
            responseModel.rawData = data
            responseModel.request = request
            
            //Print request and response object
            if request.isLoggingEnabled.0 {
                print("\n")
                debugPrint("Path: \(request.path)")
                debugPrint("Model: \(T.self)")
                debugPrint("Body:-")
                debugPrint(request.body)
            }
            if request.isLoggingEnabled.1 {
                if let responseJSON = try? JSONDecoder().decode(T.self, from: rawData).asDictionary() {
                    debugPrint("Response:-")
                    debugPrint(responseJSON)
                }
            }
            
            if let data = responseModel.data {
                completion(data, nil)
            } else {
                completion([], RMErrorModel.generalError())
            }
        }.resume()
    }
}
