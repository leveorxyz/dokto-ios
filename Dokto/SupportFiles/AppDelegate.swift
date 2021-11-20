//
//  AppDelegate.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit
import PayPalCheckout
import GoogleMaps
import IQKeyboardManagerSwift

#if DEBUG
let DEBUG: Int = 1
#else
let DEBUG: Int = 0
#endif

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
        
        //MARK: GMS service key
        GMSServices.provideAPIKey(Constants.Keys.GoogleMap.current)
        
        //MARK: IQKeyboardManager config
        IQKeyboardManager.shared.enable = true
        
        //MARK: Initiate root view
        initiateRootViewController()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

//MARK: Other methods
extension AppDelegate {
    
    func initiateRootViewController() {
        let onboardingIsDisplayed = UserDefaults.standard.bool(forKey: Constants.Keys.UserDefaults.onboardingIsDisplayed)
        
        if !onboardingIsDisplayed, let controller = UIStoryboard.controller(with: .onboarding, type: OnboardingViewController.self) {
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        } else if let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() {
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
}
