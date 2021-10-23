//
//  PaymentManager.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit
import RaveSDK

enum PaymentStatus {
    case success, failure, dismiss
}

class PaymentManager {
    
    var paymentCompletion: ((PaymentStatus) -> ())?
}

//MARK: FlutterWave related methods
extension PaymentManager: RavePayProtocol {
    
    func checkoutWithFlutterWave() {
        let config = RaveConfig.sharedConfig()
        config.country = "NG" // Country Code
        config.currencyCode = "NGN" // Currency
        config.email = "zahinjason220434@gmail.com" // Customer's email
        config.isStaging = false // Toggle this for staging and live environment
        config.phoneNumber = "081312121212" //Phone number
        config.transcationRef = "ref" // transaction ref
        config.firstName = "Jason"
        config.lastName = "Haque"
        config.meta = [["metaname":"sdk", "metavalue":"ios"]]
        
        config.publicKey = "FLWPUBK_TEST-cef158ec1b1213690fbeeccb930be993-X" //Public key
        config.encryptionKey = "FLWSECK_TEST6207416b757f" //Encryption key
        
        
        let controller = NewRavePayViewController()
        let nav = UINavigationController(rootViewController: controller)
        controller.amount = "120"
        controller.delegate = self
        UIApplication.topViewController()?.present(nav, animated: true)
    }
    
    func tranasctionSuccessful(flwRef: String?, responseData: [String : Any]?) {
        //print("Successfully paid with rave \(flwRef!) \n \(responseData!)")
        guard let response = responseData else{
            return
        }
        
        //request for backend verification
        let request = RMRequestModel()
        request.path = "http://159.203.72.156/accounting/flutterwave-verify/"
        request.body = [
            "transaction_reference" : response["id"] ?? "1234567",
            "id" : "1"
        ]
        
        RequestManager.request(request: request, type: PaymentResponseDetails.self) { [weak self] response, error in
            if let _ = response.first {
                debugPrint("Payment verified")
                self?.paymentCompletion?(.success)
            } else {
                debugPrint("Payment verification failed")
                self?.paymentCompletion?(.failure)
            }
        }
    }
    
    func tranasctionFailed(flwRef: String?, responseData: [String : Any]?) {
        print("Failed to pay with rave \(flwRef!) \n \(responseData!)")
        self.paymentCompletion?(.failure)
    }
    
    func onDismiss() {
        print("Rave pay Dismissed")
        self.paymentCompletion?(.dismiss)
    }
}
