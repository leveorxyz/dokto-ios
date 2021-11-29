//
//  DoctorPersonalDetailsVC.swift
//  Dokto
//
//  Created by Rupak on 11/26/21.
//

import UIKit

class DoctorPersonalDetailsVC: AbstractViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
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
    var selectedCountryCode: IDName? {
        didSet {
            countryCodeTextField.text = selectedCountryCode?.key
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
extension DoctorPersonalDetailsVC {
    
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
extension DoctorPersonalDetailsVC: UITableViewDataSource, UITableViewDelegate {
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
extension DoctorPersonalDetailsVC {
    
    @objc func birthDateChanged(sender: UIDatePicker) {
        selectedDate = sender.date
    }
}

//MARK: UITextFieldDelegate methods
extension DoctorPersonalDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthDateTextField {
            return false
        }
        return true
    }
}

//MARK: Other methods
extension DoctorPersonalDetailsVC {
    
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
        } else if fullNameTextField.text == "" {
            AlertManager.showAlert(title: "Full name is required")
            errorField = fullNameTextField
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
        fullNameTextField.text = "Full name"
        selectedCountryCode = IDName(key: "880", name: "Bangladesh")
        mobileNumberTextField.text = "1913243746"
        emailTextField.text = "test1@test.com"
        passwordTextField.text = "123456"
        confirmPasswordTextField.text = "123456"
        selectedDate = Date()
    }
    
    func updatePatientSignUpRequestDetails() {
        if DataManager.shared.doctorSignUpRequestDetails == nil {
            DataManager.shared.doctorSignUpRequestDetails = DoctorSignUpRequestDetails()
        }
        
        //update values
        let object = DataManager.shared.doctorSignUpRequestDetails
        object?.profilePhoto = profileImage?.toBase64()
        object?.fullName = fullNameTextField.text
        object?.contactNo = mobileNumberTextField.text
        object?.email = emailTextField.text
        object?.password = passwordTextField.text
        object?.gender = selectedGender.rawValue
        object?.dateOfBirth = birthDateTextField.text
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
                self.selectedCountryCode = item
            }
        }
    }
}
