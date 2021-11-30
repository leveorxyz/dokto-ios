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
