//
//  ClinicRegistrationViewController.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 29/11/21.
//

import UIKit

class ClinicRegistrationViewController: UIViewController {

    
    @IBOutlet weak var clinicImageView: UIImageView!
    @IBOutlet weak var hospitalNameField: UITextField!
    @IBOutlet weak var mobileNumberCountryCodeField: UITextField!
    @IBOutlet weak var mobilenumberField: UITextField!
    @IBOutlet weak var mobileNumberdropDownButton: UIButton!
    @IBOutlet weak var clinicEmailField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var NumberofPractitionersField: UITextField!
    @IBOutlet weak var countrySelectField: UITextField!
    @IBOutlet weak var countrySelectButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateSelectField: UITextField!
    @IBOutlet weak var stateSelectButton: UIButton!
    @IBOutlet weak var citySelectField: UITextField!
    @IBOutlet weak var citySelectButton: UIButton!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK - Action methods
extension ClinicRegistrationViewController{
    @IBAction func setProfileLogoAction(_ sender: Any) {
        print("Choose photo tapped")
    }
    
    @IBAction func mobileNumberDropDownAction(_ sender: Any) {
        print("Mobile number drop down tapped")
    }
    
    @IBAction func countrySelectAction(_ sender: Any) {
        print("country select tapped")
    }
    
    @IBAction func stateSelectAction(_ sender: Any) {
        print("State select Tapped")
    }
    
    @IBAction func citySelectAction(_ sender: Any) {
        print("City select Tapped")
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        print("Submit Select tapped")
    }
    
}
