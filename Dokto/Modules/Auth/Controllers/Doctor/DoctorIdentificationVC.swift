//
//  DoctorIdentificationVC.swift
//  Dokto
//
//  Created by Rupak on 11/27/21.
//

import UIKit

class DoctorIdentificationVC: AbstractViewController {

    @IBOutlet weak var identificationTypeTextField: UITextField!
    @IBOutlet weak var identificationNumberTextField: UITextField!
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    var genericViewModel = GenericViewModel()
    var documentImage: UIImage? {
        didSet {
            documentImageView.image = documentImage
        }
    }
    var nextActionCompletion: ((Bool) -> ())?
    var stateList = [StateListItemDetails]()
    var selectedState: StateListItemDetails? {
        didSet {
            stateTextField.text = selectedState?.name
        }
    }
    var identificationTypeList = [IDName]()
    var selectedIdentificationType: IDName? {
        didSet {
            self.identificationTypeTextField.text = selectedIdentificationType?.name
        }
    }
    var countryList = [CountryListItemDetails]()
    var selectedCountry: CountryListItemDetails? {
        didSet {
            countryTextField.text = selectedCountry?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        if AppUtility.isDebugMode() {
            self.loadDummyData()
        }
    }
}

//MARK: Action methods
extension DoctorIdentificationVC {
    
    @IBAction func photoAction(_ sender: Any) {
        TaskManager.shared.getPhotoWith(size: CGSize(width: 256, height: 256)) { [weak self] image in
            self?.documentImage = image
            self?.choosePhotoButton.isHidden = true
            self?.editPhotoButton.isHidden = false
        }
    }
    
    @IBAction func identificationTypeAction(_ sender: Any) {
        self.showSelectionList(title: "Select identification type", objectList: identificationTypeList) { item, index in
            DispatchQueue.main.async {
                self.selectedIdentificationType = item
            }
        }
    }
    
    @IBAction func countryAction(_ sender: Any) {
        if countryList.isEmpty {
            LoadingManager.showProgress()
            genericViewModel.getCountryList { object, error in
                LoadingManager.hideProgress()
                if let list = object?.result, !list.isEmpty {
                    self.countryList = list
                    DispatchQueue.main.async {
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
    
    @IBAction func stateListAction(_ sender: Any) {
        if selectedCountry == nil {
            AlertManager.showAlert(title: "Select country first!")
            return
        }
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
    
    @IBAction func nextAction(_ sender: Any) {
        if !isValidInformation() {return}
        //update request object
        self.updatePatientSignUpRequestDetails()
        nextActionCompletion?(true)
    }
}

//MARK: Other methods
extension DoctorIdentificationVC {
    
    func initialSetup() {
        //load identification type
        identificationTypeList = [.init(key: "1", name: "Passport"),
                                  .init(key: "2", name: "Driving Licence"),
                                  .init(key: "3", name: "National ID")]
    }
    
    func isValidInformation() -> Bool {
        var errorField: UITextField?
        var errorFound = false
        if identificationTypeTextField.text == "" {
            AlertManager.showAlert(title: "Identification type is required")
            errorFound = true
        } else if identificationNumberTextField.text == "" {
            AlertManager.showAlert(title: "Identification number is required")
            errorField = identificationNumberTextField
            errorFound = true
        } else if documentImage == nil {
            AlertManager.showAlert(title: "Document is required")
            errorFound = true
        } else if addressTextField.text == "" {
            AlertManager.showAlert(title: "Address is required")
            errorField = addressTextField
            errorFound = true
        } else if countryTextField.text == "" {
            AlertManager.showAlert(title: "Country is required")
            errorField = countryTextField
            errorFound = true
        } else if stateTextField.text == "" {
            AlertManager.showAlert(title: "State is required")
            errorFound = true
        } else if cityTextField.text == "" {
            AlertManager.showAlert(title: "City is required")
            errorFound = true
        } else if zipCodeTextField.text == "" {
            AlertManager.showAlert(title: "Zip code is required")
            errorField = zipCodeTextField
            errorFound = true
        }
        
        errorField?.becomeFirstResponder()
        return !errorFound
    }
    
    func loadDummyData() {
        selectedIdentificationType = identificationTypeList.first
        identificationNumberTextField.text = "3479738523872"
        addressTextField.text = "test address"
        countryTextField.text = "Bangladesh"
        stateTextField.text = "Dhaka Division"
        cityTextField.text = "Dhaka"
        zipCodeTextField.text = "1212"
        documentImage = UIImage.defaultProfile()
    }
    
    func updatePatientSignUpRequestDetails() {
        let object = DataManager.shared.doctorSignUpRequestDetails
        object?.identificationType = identificationTypeTextField.text
        object?.identificationNumber = identificationNumberTextField.text
        object?.identificationPhoto = documentImage?.toBase64()
        object?.street = addressTextField.text
        object?.country = countryTextField.text
        object?.state = stateTextField.text
        object?.city = cityTextField.text
        object?.zipCode = zipCodeTextField.text
    }
    
    func getCountryCodeIDList() -> [IDName] {
        var list = [IDName]()
        for object in stateList {
            list.append(IDName(key: object.stateCode, name: object.name))
        }
        return list
    }
    
    func getCountryList() -> [IDName] {
        var list = [IDName]()
        for object in countryList {
            list.append(IDName(key: object.countryCode, name: object.name))
        }
        return list
    }
    
    func showCountryList() {
        self.showSelectionList(title: "Select country", objectList: getCountryList()) { [weak self] item, index in
            DispatchQueue.main.async {
                let countryDetails = self?.countryList.filter({$0.countryCode == item.key}).first
                if self?.selectedCountry?.countryCode != countryDetails?.countryCode {
                    self?.selectedCountry = countryDetails
                    self?.stateList = []
                    self?.selectedState = nil
                }
            }
        }
    }
    
    func showStateList() {
        self.showSelectionList(title: "Select state", objectList: getCountryCodeIDList()) { [weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedState = self?.stateList.filter({$0.stateCode == item.key}).first
            }
        }
    }
}
