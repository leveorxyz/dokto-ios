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
    var countryList = [CountryListItemDetails]()
    var stateList = [StateListItemDetails]()
    var selectedCountry : CountryListItemDetails? {
        didSet{
            countrySelectField.text = selectedCountry?.name
        }
    }
    var selectedState: StateListItemDetails? {
        didSet {
            stateSelectField.text = selectedState?.name
        }
    }
    
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
        if countryList.isEmpty{
            LoadingManager.showProgress()
            genericViewModel.getCountryList { object, error in
                LoadingManager.hideProgress()
                
                if let list = object?.result, !list.isEmpty{
                    self.countryList = list
                    DispatchQueue.main.async{
                        self.showCountryList()
                    }
                } else if let message  = object?.message ?? error?.message {
                    AlertManager.showAlert(title: message)
                }
            }
            return
        }
        self.showCountryList()
    }
    
    @IBAction func stateSelectAction(_ sender: Any) {
        guard  self.selectedCountry != nil else{
            return
        }
        //print(selectedCountry?.countryCode)
        stateList = []
        if stateList.isEmpty {
            let params: [String: Any] = ["country_code" : selectedCountry?.countryCode ?? "BD"]
            LoadingManager.showProgress()
            genericViewModel.getStateList(params: params) { object, error in
                LoadingManager.hideProgress()
                if let list = object?.result, !list.isEmpty {
                    self.stateList = list
                    DispatchQueue.main.async {
                        self.showStateList()
                    }
                } else if let message  = object?.message ?? error?.message {
                    AlertManager.showAlert(title: message)
                }
            }
            return
        }
        self.showStateList()
        
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
    
    func showCountryList() {
        self.showSelectionList(title: "Select country", objectList: getCountryIDList()) {[weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedCountry = self?.countryList.filter({$0.countryCode == item.country_code}).first
            }
        }
    }
    
    func getCountryIDList() -> [IDName] {
        var list = [IDName]()
        for object in countryList {
            list.append(IDName(country_code: object.countryCode, name: object.name))
        }
        return list
    }
    
    func getStateIDList() -> [IDName] {
        var list = [IDName]()
        for object in stateList {
            list.append(IDName(key: object.stateCode, name: object.name))
        }
        return list
    }
    
    func showStateList() {
        self.showSelectionList(title: "Select state", objectList: getStateIDList()) { [weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedState = self?.stateList.filter({$0.stateCode == item.key}).first
            }
        }
    }
}
