//
//  SignInViewController.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//MARK: Action methods
extension SignInViewController {
    
    @IBAction func signInAction(_ sender: Any) {
        if let controller = UIStoryboard.controller(with: .dashboard, type: DashboardViewController.self) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
