//
//  SignInViewController.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordViewButton: UIButton!
    
    var passwordIsVisible: Bool = false {
        didSet {
            passwordTextField.isSecureTextEntry = !passwordIsVisible
            passwordViewButton.setImage(UIImage(named: passwordIsVisible ? "view_password" : "hide_password"), for: .normal)
        }
    }
    var viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //credential for debug mode
        if AppUtility.isDebugMode() {
            usernameTextField.text = "sa.akash0129@gmail.com"
            passwordTextField.text = "drsahmed01"
        }
    }
}

//MARK: Action methods
extension SignInViewController {
    
    @IBAction func signInAction(_ sender: Any) {
        guard isValidInfo(), let email = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        let params: [String:Any] = ["email" : email,
                                    "password" : password]
        
        LoadingManager.showProgress()
        viewModel.signIn(with: params) { object, error in
            LoadingManager.hideProgress()
            if object?.result != nil {
                DispatchQueue.main.async {
                    if let controller = UIStoryboard.controller(with: .dashboard, type: DashboardViewController.self) {
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            } else if let message = object?.message ?? error?.message {
                AlertManager.showAlert(title: message)
            }
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if let controller = UIStoryboard.controller(with: .auth, type: SignUpViewController.self) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func viewPasswordAction(_ sender: Any) {
        passwordIsVisible = !passwordIsVisible
    }
}

//MARK: Other methods
extension SignInViewController {
    
    func isValidInfo() -> Bool {
        var errorField: UITextField?
        var errorFound = false
        if usernameTextField.text == "" {
            AlertManager.showAlert(title: "Username is required")
            errorField = usernameTextField
            errorFound = true
        } else if passwordTextField.text == "" {
            AlertManager.showAlert(title: "Password is required")
            errorField = passwordTextField
            errorFound = true
        } else if let email = usernameTextField.text, !email.isEmpty, !email.isValidEmail() {
            AlertManager.showAlert(title: "Please enter a valid email address")
            errorField = usernameTextField
            errorFound = true
        }
        
        errorField?.becomeFirstResponder()
        return !errorFound
    }
}
