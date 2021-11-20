//
//  AppUtility.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class AppUtility {
    
    class func isiPad() -> Bool {
        if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
            return true
        }
        return false
    }
    
    class func isSimulator() -> Bool {
        var simulatorStatus = false
        #if targetEnvironment(simulator)
        simulatorStatus = true
        #endif
        return simulatorStatus
    }
    
    class func isDebugMode() -> Bool {
        if DEBUG == 1 {
            return true
        }
        return false
    }
}
