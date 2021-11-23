//
//  PatientIdentificationVC.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class PatientIdentificationVC: AbstractViewController {

    @IBOutlet weak var identificationTypeTextField: UITextField!
    @IBOutlet weak var identificationNumberTextField: UITextField!
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var socialSecurityNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppUtility.isDebugMode() {
            self.loadDummyData()
        }
    }
}

//MARK: Action methods
extension PatientIdentificationVC {
    
    @IBAction func photoAction(_ sender: Any) {
        TaskManager.shared.getPhotoWith(size: CGSize(width: 256, height: 256)) { [weak self] image in
            self?.documentImage = image
            self?.choosePhotoButton.isHidden = true
            self?.editPhotoButton.isHidden = false
        }
    }
    
    @IBAction func stateListAction(_ sender: Any) {
        if stateList.isEmpty {
            let params: [String: Any] = ["country_code" : "BD"]
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
extension PatientIdentificationVC {
    
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
        } else if socialSecurityNumberTextField.text == "" {
            AlertManager.showAlert(title: "Social security number is required")
            errorField = socialSecurityNumberTextField
            errorFound = true
        } else if addressTextField.text == "" {
            AlertManager.showAlert(title: "Address is required")
            errorField = addressTextField
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
        identificationTypeTextField.text = "Passport"
        identificationNumberTextField.text = "3479738523872"
        socialSecurityNumberTextField.text = "q5623472"
        addressTextField.text = "test address"
        stateTextField.text = "Bangladesh"
        cityTextField.text = "Dhaka"
        zipCodeTextField.text = "1212"
    }
    
    func updatePatientSignUpRequestDetails() {
        let object = DataManager.shared.patientSignUpRequestDetails
        object?.identificationType = identificationTypeTextField.text
        object?.identificationNumber = identificationNumberTextField.text
        object?.identificationPhoto = documentImage?.toBase64()
        object?.socialSecurityNumber = socialSecurityNumberTextField.text
        object?.street = addressTextField.text
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
    
    func showStateList() {
        self.showSelectionList(title: "Select state", objectList: getCountryCodeIDList()) { [weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedState = self?.stateList.filter({$0.stateCode == item.key}).first
            }
        }
    }
}
