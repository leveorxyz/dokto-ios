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
        struct UserDefaults {
            static let onboardingIsDisplayed = "OnboardingIsDisplayed"
        }
        struct Api {
            static let csrfToken = "4GLgUlll1AyQjcuH3uXxAQwmNJOpW2AxOxKblLHlVsiDf5Mvow282R3A2CLnqdWh"
        }
    }
    
    struct Api {
        struct BaseUrl {
            static let dev = "https://doktoapi.toybethdev.net"
            static let prod = "https://doktoapi.toybethdev.net"
            static let current = dev
        }
        
        struct Payment {
            static let paystack = "/accounting/paystack-verify/"
            static let flutterWave = "/accounting/flutterwave-verify/"
            static let paypal = "/accounting/paypal-verify/"
            static let stripe = "/accounting/stripe-charge/"
        }
        struct Twilio{
            static let twilioTokenUrl = "/twilio/video-token/"
        }
        struct Auth {
            static let login = "/user/login/"
            struct Patient {
                static let registration = "/user/patient-signup/"
            }
        }
        struct Generic {
            static let countryCode = "/constant/phone-code/"
            static let stateList = "/constant/state/"
            static let countryList = "/constant/country/"
            static let cityList = "/constant/city/"
        }
    }
}
