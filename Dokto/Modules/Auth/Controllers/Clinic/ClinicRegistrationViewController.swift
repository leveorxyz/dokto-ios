//
//  ClinicRegistrationViewController.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 29/11/21.
//

import UIKit

class ClinicRegistrationViewController: AbstractViewController{

    
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
    
    var clinicImage: UIImage? {
        didSet {
            clinicImageView.image = clinicImage
        }
    }
    var genericViewModel = GenericViewModel()
    var countryCodeList = [CountryCodeListItemDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK - Action methods
extension ClinicRegistrationViewController{
    @IBAction func setProfileLogoAction(_ sender: Any) {
        print("Choose photo tapped")
        TaskManager.shared.getPhotoWith(size: CGSize(width: 256, height: 256)) { [weak self] image in
            self?.clinicImage = image
        }
    }
    
    @IBAction func mobileNumberDropDownAction(_ sender: Any) {
        print("Mobile number drop down tapped")
        if countryCodeList.isEmpty {
            LoadingManager.showProgress()
            genericViewModel.getCountryCodeList { object, error in
                LoadingManager.hideProgress()
                if let list = object?.result, !list.isEmpty {
                    self.countryCodeList = list
                    DispatchQueue.main.async {
                        self.showCountryCodeList()
                    }
                } else if let message  = object?.message ?? error?.message {
                    AlertManager.showAlert(title: message)
                }
            }
            return
        }
        self.showCountryCodeList()
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

extension ClinicRegistrationViewController{
    
    func getCountryCodeIDList() -> [IDName] {
        var list = [IDName]()
        for object in countryCodeList {
            let name = (object.name ?? "") + " (\(object.phoneCode ?? ""))"
            list.append(IDName(key: object.phoneCode, name: name))
        }
        return list
    }
    func showCountryCodeList() {
        self.showSelectionList(title: "Select country", objectList: getCountryCodeIDList()) { item, index in
            DispatchQueue.main.async {
                self.mobileNumberCountryCodeField.text = item.key
            }
        }
    }
}
