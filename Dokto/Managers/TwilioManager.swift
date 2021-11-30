//
//  TwilioManager.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import Foundation

enum TwilioAPIError : Error{
    case badUrl, jsonParseError,noDataFound
}

class TwilioManager{
    
    func getAccessToken(urlPath : String , body : [String : Any], _ completion : @escaping (Result<TwilioVideoTokenAPIResponse,TwilioAPIError>) -> Void){
        
        guard let url = URL(string: Constants.Api.BaseUrl.current+urlPath) else{
            print("bad URL")
            completion(.failure(.badUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData = try? JSONSerialization.data(withJSONObject: body)
        urlRequest.httpBody = requestData
        URLSession.shared.dataTask(with: urlRequest) { data, fetchedResponse , error in
            guard let data = data, error == nil else{
                print("No data found")
                completion(.failure(.noDataFound))
                
                return
            }
            do{
                let tokenResponse = try JSONDecoder().decode(TwilioVideoTokenAPIResponse.self, from: data)
                debugPrint(tokenResponse)
                completion(.success(tokenResponse))
            }
            catch{
                print("Error here")
                //completion(.failure(.jsonParseError))
                //print(error.localizedDescription)
            }
        }.resume()

        
    }
    
    
    
}
