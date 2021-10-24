//
//  DashboardViewModel.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

class DashboardViewModel {
    
    let paymentManager = PaymentManager()
}

//MARK: Payment related methods
extension DashboardViewModel {
    
    func flutterWaveCheckout(_ completion: @escaping(_ status: PaymentStatus) -> ()) {
        paymentManager.checkoutWithFlutterWave()
        paymentManager.paymentCompletion = { status in
            completion(status)
        }
    }
    
    func paystackCheckout(_ completion: @escaping(_ status: PaymentStatus) -> ()) {
        paymentManager.checkoutWithPaystack()
        paymentManager.paymentCompletion = { status in
            completion(status)
        }
    }
    
    func stripeCheckout(_ completion: @escaping(_ status: PaymentStatus) -> ()) {
        //Prepare stripe payment
        LoadingManager.showProgress()
        paymentManager.prepareStripePayment { [weak self] success in
            LoadingManager.hideProgress()
            //check status
            if success {
                DispatchQueue.main.async {
                    self?.paymentManager.checkoutWithStripe()
                    self?.paymentManager.paymentCompletion = { status in
                        completion(status)
                    }
                }
            } else {
                completion(.failure)
            }
        }
    }
}
