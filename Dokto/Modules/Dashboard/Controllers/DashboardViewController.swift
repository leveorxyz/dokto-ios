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
}
