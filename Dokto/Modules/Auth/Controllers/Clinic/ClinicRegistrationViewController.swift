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
    var clinicViewModel = ClinicRegistrationViewModel()
    var countryCodeList = [CountryCodeListItemDetails]()
    var countryList = [CountryListItemDetails]()
    var stateList = [StateListItemDetails]()
    var cityList = [String]()
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
    var selectedCity : String? {
        didSet{
            citySelectField.text = selectedCity
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
        
        guard self.selectedCountry != nil ,self.selectedState != nil else{
            return
        }
        cityList = []
        citySelectField.text = ""
        if cityList.isEmpty{
            let params: [String : Any] = [
                "country_code" : selectedCountry?.countryCode ?? "BD",
                "state_code" : selectedState?.stateCode ?? "13"
            ]
            LoadingManager.showProgress()
            
            genericViewModel.getCityList(params: params) { object, error in
                LoadingManager.hideProgress()
                if let list = object?.result, !list.isEmpty{
                    self.cityList = list
                    DispatchQueue.main.async {
                        //show a city list
                        self.showCityList()
                    }
                } else if let message  = object?.message ?? error?.message {
                    AlertManager.showAlert(title: message)
                }
            }
            return
        }
        //show a city list
        self.showCityList()
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        print("Submit Select tapped")
        //let fullName = hospitalNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if validateregistrationData(){return}
        
        let fullName = hospitalNameField.text
        let email = clinicEmailField.text
        let password = passWordField.text
        let numberOfpractitioners = NumberofPractitionersField.text
        let image = clinicImageView.image?.toBase64() ?? "String"
        let countryCode = mobileNumberCountryCodeField.text
        let number = mobilenumberField.text
        let contactNumber = "\(countryCode)\(number)"
        let countryName = countrySelectField.text
        let stateName = stateSelectField.text
        let address = addressTextField.text
        let zipCode = zipCodeField.text
        let city = citySelectField.text
        
        let registrationData : [String : Any] = [
            "street": address,
            "password": password,
            "full_name": fullName,
            "state": stateName,
            "zip_code": zipCode,
            "city": city,
            "contact_no": contactNumber,
            "email": email,
            "number_of_practitioners": numberOfpractitioners,
            "profile_photo": image
        ]
        clinicViewModel.registerClinic(with: registrationData) { data, error in
            if let data = data{
                print(data)
            }
        }
        
    }
    
}

extension ClinicRegistrationViewController{
    
    func validateregistrationData()-> Bool{
        var errorFound = false
        if hospitalNameField.text?.trimmingCharacters(in: .newlines) == "" {
            AlertManager.showAlert(title: "Enter a valid Fullname")
            errorFound = true
        }
        else if mobileNumberCountryCodeField.text == ""{
            AlertManager.showAlert(title: "Enter a mobile number")
            errorFound = true
        }
        else if mobilenumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            AlertManager.showAlert(title: "Enter a mobile number")
            errorFound = true
        }
        else if let clinicEmail = clinicEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !clinicEmail.isValidEmail() {
            AlertManager.showAlert(title: "Enter a valid email")
            errorFound = true
        }
        else if  let password = passWordField.text, password.count <= 8 {
            AlertManager.showAlert(title: "Password is too short")
            errorFound = true
        }
        else if let password = passWordField.text,let confirmPassword = confirmPasswordField.text , confirmPassword != password {
            AlertManager.showAlert(title: "Passwords do not match")
            errorFound = true
        }
        
        else if clinicImageView.image == nil {
            AlertManager.showAlert(title: "Enter a valid Image")
            errorFound = true
        }
        
        return errorFound
    }
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
    func getCityList()-> [IDName]{
        var list = [IDName]()
        
        for object in cityList{
            list.append(IDName(name: object))
        }
        return list
    }
    
    func showCityList(){
        self.showSelectionList(title: "Select City", objectList: getCityList()) {[weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedCity = self?.cityList.filter({$0 == item.name}).first
            }
        }
    }
    
    func showStateList() {
        self.showSelectionList(title: "Select state", objectList: getStateIDList()) { [weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedState = self?.stateList.filter({$0.stateCode == item.key}).first
            }
        }
    }
}
