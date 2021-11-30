//
//  IDName.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class IDName: NSObject {
    
    var id : Int?
    var name : String?
    var key: String?
    var country_code : String?
    
    override init() {}
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    init(key: String?, name: String?) {
        self.key = key
        self.name = name
    }
    init(country_code: String? , name: String?){
        self.name = name
        self.country_code = country_code
    }
    init(name : String){
        self.name = name
    }
}
