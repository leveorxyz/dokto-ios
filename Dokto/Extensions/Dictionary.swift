//
//  Dictionary.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

extension Dictionary {
    
    func asObject<T: Codable>(type: T.Type) -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted), let object = try? JSONDecoder().decode(type, from: jsonData) else {
            return nil
        }
        return object
    }
}

extension Encodable {
    
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self), let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
