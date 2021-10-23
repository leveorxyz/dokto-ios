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
}
