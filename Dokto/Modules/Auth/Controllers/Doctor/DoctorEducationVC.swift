//
//  DoctorEducationVC.swift
//  Dokto
//
//  Created by Rupak on 11/27/21.
//

import UIKit

enum LanguageType: String {
    case english = "English"
    case spanish = "Spanish"
    case french = "French"
    case none
}

class DoctorEducationVC: AbstractViewController {
    
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var educationTableView: UITableView!
    @IBOutlet weak var specialityTextField: UITextField!
    
    @IBOutlet weak var languageTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationTableViewHeightConstraint: NSLayoutConstraint!
    
    var educationCellHeight = 576
    var nextActionCompletion: ((Bool) -> ())?
    var genericViewModel = GenericViewModel()
    var doctorSignUpViewModel = DoctorSignUpViewModel()
    var languageList: [LanguageType] = [.english, .spanish, .french]
    var selectedLanguageList: Set<LanguageType> = []
    var educationList = [DoctorSignUpRequestEducationDetails]()
    var specialityList: Set<String> = []
    var selectedSpecialityList: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        if AppUtility.isDebugMode() {
            self.loadDummyData()
        }
    }
}

//MARK: Action methods
extension DoctorEducationVC {
    
    @IBAction func insuranceTypeAction(_ sender: Any) {
        self.showSelectionList(title: "Select speciality", objectList: getSpecialityList()) { [weak self] item, index in
            if let name = item.name {
                self?.selectedSpecialityList.insert(name)
            }
        }
    }
    
    @IBAction func addEducationAction(_ sender: Any) {
        educationList.insert(DoctorSignUpRequestEducationDetails(), at: 0)
        educationTableView.reloadData()
        self.updateEducationListHeight()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !isValidInformation() {return}
        //update request object
        self.updateDoctorSignUpRequestDetails()
        nextActionCompletion?(true)
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate methods
extension DoctorEducationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == languageTableView {
            return languageList.count
        }
        return educationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == languageTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenderTableViewCell") as? GenderTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            let item = languageList[indexPath.row]
            cell.updateWith(object: item, isSelected: selectedLanguageList.contains(item))
            
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorEducationTableViewCell") as? DoctorEducationTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.delegate = self
        
        let item = educationList[indexPath.row]
        let profileIndex = educationList.count > 1 ? (educationList.count - indexPath.row) : nil
        cell.updateWith(object: item, profileIndex: profileIndex)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == languageTableView {
            return 44
        }
        return CGFloat(educationList.count > 1 ? educationCellHeight : educationCellHeight - 44)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == languageTableView {
            let item = languageList[indexPath.row]
            if selectedLanguageList.contains(item) {
                selectedLanguageList.remove(item)
            } else {
                selectedLanguageList.insert(item)
            }
            tableView.reloadData()
        }
    }
}

//MARK: DoctorEducationTableViewCellDelegate methods
extension DoctorEducationVC: DoctorEducationTableViewCellDelegate {
    
    func clickedOnDelete(with cell: DoctorEducationTableViewCell) {
        guard let indexPath = educationTableView.indexPath(for: cell) else {return}
        self.educationList.remove(at: indexPath.row)
        self.educationTableView.reloadData()
        self.updateEducationListHeight()
    }
}

//MARK: Other methods
extension DoctorEducationVC {
    
    func initialSetup() {
        languageTableViewHeightConstraint.constant = CGFloat(languageList.count * 44)
        languageTableView.reloadData()
        
        educationList = []
        educationList.append(DoctorSignUpRequestEducationDetails())
        educationTableView.reloadData()
        self.updateEducationListHeight()
        
        specialityList = Set(doctorSignUpViewModel.getSpecialityList())
    }
    
    func isValidInformation() -> Bool {
        var errorField: UITextField?
        var errorFound = false
        if selectedLanguageList.count == 0 {
            AlertManager.showAlert(title: "Select at least one language")
            errorFound = true
        } else if !isValidEducationInfo() {
            AlertManager.showAlert(title: "Please check your entered education info")
            errorFound = true
        } else if specialityTextField.text == "" {
            AlertManager.showAlert(title: "Speciality is required")
            errorField = specialityTextField
            errorFound = true
        }
        
        errorField?.becomeFirstResponder()
        return !errorFound
    }
    
    func isValidEducationInfo() -> Bool {
        var isValid = true
        for education in educationList {
            if education.college == nil || education.course == nil || education.year == nil || education.certificateImage == nil {
                isValid = false
            }
        }
        return isValid
    }
    
    func loadDummyData() {
        selectedLanguageList = [.english, .french]
        let education = DoctorSignUpRequestEducationDetails()
        education.college = "test college"
        education.course = "test course"
        education.year = "2021-11-29"
        let image = UIImage(named: "default_profile")
        education.certificate = image?.toBase64()
        education.certificateImage = image
    }
    
    func updateDoctorSignUpRequestDetails() {
        let object = DataManager.shared.doctorSignUpRequestDetails
        object?.education = educationList
        object?.language = languageList.map({$0.rawValue})
        object?.specialty = Array(selectedSpecialityList)
    }
    
    func getSpecialityList() -> [IDName] {
        var list = [IDName]()
        let finalList = specialityList.subtracting(selectedSpecialityList)
        for (index, value) in finalList.enumerated() {
            list.append(IDName(id: index, name: value))
        }
        return list
    }
    
    func updateEducationListHeight() {
        let height = educationList.count > 1 ? educationCellHeight : (educationCellHeight - 44)
        educationTableViewHeightConstraint.constant = CGFloat(educationList.count * height)
    }
}
