//
//  PatientPersonalDetailsVC.swift
//  Dokto
//
//  Created by Rupak on 11/19/21.
//

import UIKit

enum GenderType: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case notToSay = "Prefer not to say"
    case none
}

class PatientPersonalDetailsVC: AbstractViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderTableView: UITableView!
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet weak var genderTableViewHeightConstraint: NSLayoutConstraint!
    
    var profileImage: UIImage? {
        didSet {
            profileImageView.image = profileImage
        }
    }
    var nextActionCompletion: ((Bool) -> ())?
    var genderList: [GenderType] = [.male, .female, .other, .notToSay]
    var selectedGender: GenderType = .male
    let timePicker = UIDatePicker()
    var selectedDate = Date() {
        didSet {
            birthDateTextField.text = selectedDate.dateString(with: "YYYY-MM-dd", local: true)
        }
    }
    
    var genericViewModel = GenericViewModel()
    var countryCodeList = [CountryCodeListItemDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        if AppUtility.isDebugMode() {
            self.loadDummyData()
        }
    }
}

//MARK: Action methods
extension PatientPersonalDetailsVC {
    
    @IBAction func photoAction(_ sender: Any) {
        TaskManager.shared.getPhotoWith(size: CGSize(width: 256, height: 256)) { [weak self] image in
            self?.profileImage = image
        }
    }
    
    @IBAction func countryCodeAction(_ sender: Any) {
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
    
    @IBAction func nextAction(_ sender: Any) {
        if !isValidInformation() {return}
        //update request object
        self.updatePatientSignUpRequestDetails()
        nextActionCompletion?(true)
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate methods
extension PatientPersonalDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenderTableViewCell") as? GenderTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let item = genderList[indexPath.row]
        cell.updateWith(object: item, isSelected: item == self.selectedGender)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGender = genderList[indexPath.row]
        tableView.reloadData()
    }
}

//MARK: Action methods
extension PatientPersonalDetailsVC {
    
    @objc func birthDateChanged(sender: UIDatePicker) {
        selectedDate = sender.date
    }
}

//MARK: UITextFieldDelegate methods
extension PatientPersonalDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthDateTextField {
            return false
        }
        return true
    }
}

//MARK: Other methods
extension PatientPersonalDetailsVC {
    
    func initialSetup() {
        genderTableViewHeightConstraint.constant = CGFloat(genderList.count * 44)
        
        //inline date selector
        timePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        timePicker.maximumDate = maximumDate
        timePicker.tintColor = .white
        timePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        timePicker.backgroundColor = .clear
        timePicker.addTarget(self, action: #selector(birthDateChanged), for: .valueChanged)
        birthDateTextField.delegate = self
        birthDateTextField.inputView = timePicker
    }
    
    func isValidInformation() -> Bool {
        var errorField: UITextField?
        var errorFound = false
        if profileImage == nil {
            AlertManager.showAlert(title: "Profile image is required")
            errorFound = true
        } else if firstNameTextField.text == "" {
            AlertManager.showAlert(title: "First name is required")
            errorField = firstNameTextField
            errorFound = true
        } else if lastNameTextField.text == "" {
            AlertManager.showAlert(title: "Last name is required")
            errorField = lastNameTextField
            errorFound = true
        } else if countryCodeTextField.text == "" {
            AlertManager.showAlert(title: "Select country code")
            errorFound = true
        } else if mobileNumberTextField.text == "" {
            AlertManager.showAlert(title: "Mobile number is required")
            errorField = mobileNumberTextField
            errorFound = true
        } else if emailTextField.text == "" {
            AlertManager.showAlert(title: "Email address is required")
            errorField = emailTextField
            errorFound = true
        } else if let email = emailTextField.text, !email.isEmpty, !email.isValidEmail() {
            AlertManager.showAlert(title: "Please enter a valid email address")
            errorField = emailTextField
            errorFound = true
        } else if passwordTextField.text == "" {
            AlertManager.showAlert(title: "Password is required")
            errorField = passwordTextField
            errorFound = true
        } else if confirmPasswordTextField.text == "" {
            AlertManager.showAlert(title: "Confirm password is required")
            errorField = confirmPasswordTextField
            errorFound = true
        } else if passwordTextField.text != confirmPasswordTextField.text {
            AlertManager.showAlert(title: "Both password should be same")
            errorField = confirmPasswordTextField
            errorFound = true
        } else if confirmPasswordTextField.text == "" {
            AlertManager.showAlert(title: "Date of birth is required")
            errorField = confirmPasswordTextField
            errorFound = true
        }
        
        errorField?.becomeFirstResponder()
        return !errorFound
    }
    
    func loadDummyData() {
        profileImage = UIImage(named: "default_profile")
        firstNameTextField.text = "First name"
        lastNameTextField.text = "Last name"
        countryCodeTextField.text = "880"
        mobileNumberTextField.text = "1913243746"
        emailTextField.text = "test@test.com"
        passwordTextField.text = "123456"
        confirmPasswordTextField.text = "123456"
        selectedDate = Date()
    }
    
    func updatePatientSignUpRequestDetails() {
        if DataManager.shared.patientSignUpRequestDetails == nil {
            DataManager.shared.patientSignUpRequestDetails = PatientSignUpRequestDetails()
        }
        
        //update values
        let object = DataManager.shared.patientSignUpRequestDetails
        object?.profilePhoto = profileImage?.toBase64()
        object?.fullName = getFullName()
        object?.contactNo = mobileNumberTextField.text
        object?.email = emailTextField.text
        object?.password = passwordTextField.text
        object?.gender = selectedGender.rawValue
        object?.dateOfBirth = birthDateTextField.text
    }
    
    func getFullName() -> String {
        return (firstNameTextField.text ?? "") + " " + (lastNameTextField.text ?? "")
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
                self.countryCodeTextField.text = item.key
            }
        }
    }
}
