//
//  AppDelegate.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit
import PayPalCheckout

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //paypal configuration
        let config = CheckoutConfig(
            clientID: Constants.Keys.Payment.Paypal.clientId,
            returnUrl: "com.toybethsystems.dokto://paypalpay",
            environment: .sandbox
        )
        Checkout.set(config: config)
        
        return true
    }
}
