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
       
//        let url = URL(string: "\(Constants.Api.BaseUrl.dev)\(Constants.Api.Auth.Clinic.registration)")!
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let requestData = try? JSONSerialization.data(withJSONObject: params)
//        urlRequest.httpBody = requestData
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            guard let data = data, error == nil else{
//                print("No data found")
//                //completion(.failure(.noDataFound))
//                return
//            }
//            do{
//                let registerResponse = try JSONDecoder().decode(ClinicRegistrationResponse.self, from: data)
//                //debugPrint(tokenResponse)
//                print(registerResponse)
//                //completion(.success(tokenResponse))
//            }
//            catch{
//                print("Error here \(error)")
//                //completion(.failure(.jsonParseError))
//
//            }
//        }.resume()
    }
    
}
