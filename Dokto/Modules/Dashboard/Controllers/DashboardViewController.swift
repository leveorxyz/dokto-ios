//
//  DashboardViewController.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

class DashboardViewController: UIViewController {

    private let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: Action methods
extension DashboardViewController {
    
    @IBAction func flutterWaveAction(_ sender: Any) {
        viewModel.flutterWaveCheckout { status in
            debugPrint(status)
        }
    }
    
    @IBAction func paystackAction(_ sender: Any) {
        viewModel.paystackCheckout { status in
            debugPrint(status)
        }
    }
    
    @IBAction func stripeAction(_ sender: Any) {
//        LoadingManager.showProgress()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            LoadingManager.hideProgress()
//        }
        viewModel.stripeCheckout { status in
            debugPrint(status)
        }
    }
}
