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
                static let prod = "AVXS2Vs7A7-pEKTmamJt42cYtl_sZY5DEW86JUB-Go2kTJAuWGMzSHV9j7bVu1JsSucNFmWBkjvYPqoo"
                static let clientId = dev
            }
        }
        struct GoogleMap {
            static let current = "AIzaSyC3jKbpRiXpO2hcQq12umTYmpCj8Wy9_so"
        }
    }
    
    struct Api {
        struct BaseUrl {
            static let dev = "http://159.203.72.156"
            static let prod = "http://159.203.72.156"
            static let current = dev
        }
        
        struct Payment {
            static let paystack = "/accounting/paystack-verify/"
            static let flutterWave = "/accounting/flutterwave-verify/"
            static let paypal = "/accounting/paypal-verify/"
            static let stripe = "/accounting/stripe-charge/"
        }
    }
}
