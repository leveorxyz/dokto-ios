//
//  Constants.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

struct Constants {

    struct Keys {
        struct Payment {
            struct Paypal {
                static let dev = "Ae9uJS2DkP2L0fqXxhOhnE1ek2FGvV5PV7-wYvuQtB3mvBaTCp3HhWPKOQTf4unMwainGxx9KoV6R5PX"
                static let prod = "Ae9uJS2DkP2L0fqXxhOhnE1ek2FGvV5PV7-wYvuQtB3mvBaTCp3HhWPKOQTf4unMwainGxx9KoV6R5PX"
                static let clientId = dev
            }
        }
        struct GoogleMap {
            static let current = "AIzaSyC3jKbpRiXpO2hcQq12umTYmpCj8Wy9_so"
        }
    }
    
    struct Api {
        struct BaseUrl {
            static let dev = ""
            static let qa = ""
            static let prod = ""
            static let current = dev
        }
    }
}
