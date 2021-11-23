//
//  PatientHealthcareVC.swift
//  Dokto
//
//  Created by Rupak on 11/22/21.
//

import UIKit

class PatientHealthcareVC: AbstractViewController {
    
    @IBOutlet weak var referringDoctorAddressTextField: UITextField!
    @IBOutlet weak var referringDoctorNameTextField: UITextField!
    @IBOutlet weak var referringDoctorNumberTextField: UITextField!
    @IBOutlet weak var insuranceTypeTextField: UITextField!
    @IBOutlet weak var insuranceNameTextField: UITextField!
    @IBOutlet weak var insuranceNumberTextField: UITextField!
    @IBOutlet weak var insurancePolicyHolderTextField: UITextField!
    @IBOutlet weak var insuranceNameView: UIView!
    @IBOutlet weak var insuranceNumberView: UIView!
    @IBOutlet weak var insurancePolicyHolderNameView: UIView!
    
    var genericViewModel = GenericViewModel()
    var nextActionCompletion: ((Bool) -> ())?
    var selectedInsuranceType: IDName? {
        didSet {
            insuranceTypeTextField.text = selectedInsuranceType?.name
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
extension PatientHealthcareVC {
    
    @IBAction func insuranceTypeAction(_ sender: Any) {
        let typeList = getInsuranceTypeList()
        self.showSelectionList(title: "Select insurance type", objectList: typeList) { [weak self] item, index in
            DispatchQueue.main.async {
                self?.selectedInsuranceType = typeList.filter({$0.key == item.key}).first
                self?.showInsuranceVerifieInfo(show: item.key == "2")
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !isValidInformation() {return}
        //update request object
        self.updatePatientSignUpRequestDetails()
        nextActionCompletion?(true)
    }
}

//MARK: Other methods
extension PatientHealthcareVC {
    
    func initialSetup() {
        self.showInsuranceVerifieInfo(show: false)
    }
    
    func isValidInformation() -> Bool {
        var errorField: UITextField?
        var errorFound = false
        if referringDoctorAddressTextField.text == "" {
            AlertManager.showAlert(title: "Referring doctor address is required")
            errorField = referringDoctorAddressTextField
            errorFound = true
        } else if referringDoctorNameTextField.text == "" {
            AlertManager.showAlert(title: "Referring doctor name is required")
            errorField = referringDoctorNameTextField
            errorFound = true
        } else if referringDoctorNumberTextField.text == "" {
            AlertManager.showAlert(title: "Referring doctor number is required")
            errorField = referringDoctorNumberTextField
            errorFound = true
        } else if selectedInsuranceType == nil {
            AlertManager.showAlert(title: "Select insurance type")
            errorFound = true
        } else if selectedInsuranceType?.key == "2" {
            if insuranceNameTextField.text == "" {
                AlertManager.showAlert(title: "Insurance name is required")
                errorField = insuranceNameTextField
                errorFound = true
            } else if insuranceNumberTextField.text == "" {
                AlertManager.showAlert(title: "Insurance number is required")
                errorField = insuranceNumberTextField
                errorFound = true
            } else if insurancePolicyHolderTextField.text == "" {
                AlertManager.showAlert(title: "Insurance policy holder name is required")
                errorField = insurancePolicyHolderTextField
                errorFound = true
            }
        }
        
        errorField?.becomeFirstResponder()
        return !errorFound
    }
    
    func loadDummyData() {
        referringDoctorAddressTextField.text = "r test address"
        referringDoctorNameTextField.text = "r name"
        referringDoctorNumberTextField.text = "236468232"
        selectedInsuranceType = IDName(key: "1", name: "Self paid")
        insuranceNameTextField.text = "test name"
        insuranceNumberTextField.text = "678682368"
        insurancePolicyHolderTextField.text = "test holder name"
    }
    
    func updatePatientSignUpRequestDetails() {
        let object = DataManager.shared.patientSignUpRequestDetails
        object?.referringDoctorAddress = referringDoctorAddressTextField.text
        object?.referringDoctorFullName = referringDoctorNameTextField.text
        object?.referringDoctorPhoneNumber = referringDoctorNumberTextField.text
        object?.insuranceType = selectedInsuranceType?.name
        if selectedInsuranceType?.key == "2" {
            object?.insuranceName = insuranceNameTextField.text
            object?.insuranceNumber = insuranceNumberTextField.text
            object?.insurancePolicyHolderName = insurancePolicyHolderTextField.text
        } else {
            object?.insuranceName = nil
            object?.insuranceNumber = nil
            object?.insurancePolicyHolderName = nil
        }
    }
    
    func getInsuranceTypeList() -> [IDName] {
        var list = [IDName]()
        list.append(IDName(key: "1", name: "Self paid"))
        list.append(IDName(key: "2", name: "Insurance verified"))
        return list
    }
    
    func showInsuranceVerifieInfo(show: Bool) {
        insuranceNameView.isHidden = !show
        insuranceNumberView.isHidden = !show
        insurancePolicyHolderNameView.isHidden = !show
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
