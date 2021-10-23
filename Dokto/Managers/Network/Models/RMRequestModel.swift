//
//  RMRequestModel.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

public enum RMHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class RMRequestModel: NSObject {
    
    var path: String = ""
    var parameters: [String: Any?] = [:]
    var headers: [String: String] = [:]
    var body: [String: Any] = [:]
    var method: RMHTTPMethod = .get
    
    // (request, response) print
    var isLoggingEnabled: (Bool, Bool) {
        return (true, true)
    }
}

// MARK: - Public Functions
extension RMRequestModel {
    
    func urlRequest() -> URLRequest {
        var endpoint: String = Constants.Api.BaseUrl.current.appending(path)
        if path.contains("http://")  || path.contains("https://") {
            endpoint = path
        }
        
        for (index,parameter) in parameters.enumerated() {
            if let value = parameter.value {
                endpoint.append("\(index == 0 ? "?" : "&")\(parameter.key)=\(value)")
            }
        }
        
        var request: URLRequest = URLRequest(url: URL(string: endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if method == RMHTTPMethod.post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                print("Request body parse error: \(error.localizedDescription)")
            }
        }
        
        return request
    }
}
