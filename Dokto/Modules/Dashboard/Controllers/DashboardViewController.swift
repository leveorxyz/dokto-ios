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
        
        viewModel.paymentManager.initiatePaypalButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: Action methods
extension DashboardViewController {
    
    @IBAction func flutterWaveAction(_ sender: Any) {
        viewModel.flutterWaveCheckout { status in
            debugPrint(status)
            if status == .success {
                AlertManager.showAlert(title: "FlutterWave payment completed successfully")
            }
        }
    }
    
    @IBAction func paystackAction(_ sender: Any) {
        viewModel.paystackCheckout { status in
            debugPrint(status)
            if status == .success {
                AlertManager.showAlert(title: "Paystack payment completed successfully")
            }
        }
    }
    
    @IBAction func stripeAction(_ sender: Any) {
        viewModel.stripeCheckout { status in
            debugPrint(status)
            if status == .success {
                AlertManager.showAlert(title: "Stripe payment completed successfully")
            }
        }
    }
    
    @IBAction func paypalAction(_ sender: Any) {
        viewModel.paypalCheckout { status in
            debugPrint(status)
            if status == .success {
                AlertManager.showAlert(title: "PayPal payment completed successfully")
            }
        }
    }
    
    @IBAction func mapAction(_ sender: Any) {
        if let controller = UIStoryboard.controller(with: .dashboard, type: DoctorListMapViewController.self) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func videoAction(_ sender : Any){
        //Go to Video
        if let controller = UIStoryboard.controller(with: .dashboard, type: TwilioRoomViewController.self) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
