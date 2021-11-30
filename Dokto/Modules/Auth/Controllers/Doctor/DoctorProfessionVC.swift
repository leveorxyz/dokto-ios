//
//  DoctorProfessionVC.swift
//  Dokto
//
//  Created by Rupak on 11/29/21.
//

import UIKit

class DoctorProfessionVC: AbstractViewController {
    
    @IBOutlet weak var professionBioTextView: UITextView!
    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var insuranceCollectionView: UICollectionView!
    @IBOutlet weak var licenceImageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var awardsTextView: UITextView!
    @IBOutlet weak var acceptAllInsuranceCheckImageView: UIImageView!
    @IBOutlet weak var acceptedInsuranceView: UIView!
    @IBOutlet weak var businessAgreementSelectionView: GroupSelectionView!
    @IBOutlet weak var hipaaAgreementSelectionView: GroupSelectionView!
    @IBOutlet weak var gdprLawsSelectionView: GroupSelectionView!
    @IBOutlet weak var termsCheckImageView: UIImageView!
    @IBOutlet weak var termsTextView: UITextView!
    
    @IBOutlet weak var experienceTableViewHeightConstraint: NSLayoutConstraint!
    
    var experienceCellHeight = 610
    var nextActionCompletion: ((Bool) -> ())?
    var genericViewModel = GenericViewModel()
    var doctorSignUpViewModel = DoctorSignUpViewModel()
    var experienceList = [DoctorSignUpRequestExperienceDetails]()
    var insurancesList: Set<String> = []
    var acceptedInsuranceList: Set<String> = []
    var licenceImage: UIImage? {
        didSet {
            licenceImageView.image = licenceImage
        }
    }
    var isAcceptedAllInsurance = false {
        didSet {
            acceptedInsuranceView.isHidden = isAcceptedAllInsurance
        }
    }
    var isTermsSelected = false {
        didSet {
            termsCheckImageView.tintColor = isTermsSelected ? .named(._A42BAD) : .white.withAlphaComponent(0.5)
            termsCheckImageView.image = UIImage(named: isTermsSelected ? "check_filled" : "check_blank")
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
extension DoctorProfessionVC {
    
    @IBAction func acceptedInsuranceAction(_ sender: Any) {
        self.showSelectionList(title: "Select insurance", objectList: getInsuranceList()) { [weak self] item, index in
            if let name = item.name {
                self?.acceptedInsuranceList.insert(name)
                self?.acceptedInsuranceList = Set(self?.acceptedInsuranceList.sorted() ?? [])
                self?.insuranceCollectionView.isHidden = false
                self?.insuranceCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func addExperienceAction(_ sender: Any) {
        experienceList.insert(DoctorSignUpRequestExperienceDetails(), at: 0)
        experienceTableView.reloadData()
        self.updateExperienceListHeight()
    }
    
    @IBAction func acceptAllInsuranceAction(_ sender: Any) {
        self.isAcceptedAllInsurance = !self.isAcceptedAllInsurance
    }
    
    @IBAction func termsAction(_ sender: Any) {
        isTermsSelected = !isTermsSelected
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !isValidInformation() {return}
        //update request object
        self.updateDoctorSignUpRequestDetails()
        nextActionCompletion?(true)
    }
}

//MARK: UITextViewDelegate methods
extension DoctorProfessionVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL.absoluteString)
        return false
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate methods
extension DoctorProfessionVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experienceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfessionTableViewCell") as? DoctorProfessionTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.delegate = self
        
        let item = experienceList[indexPath.row]
        let profileIndex = experienceList.count > 1 ? (experienceList.count - indexPath.row) : nil
        cell.updateWith(object: item, profileIndex: profileIndex)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(experienceList.count > 1 ? experienceCellHeight : experienceCellHeight - 44)
    }
}

//MARK: DoctorExperienceTableViewCellDelegate methods
extension DoctorProfessionVC: DoctorProfessionTableViewCellDelegate {
    
    func clickedOnDelete(with cell: DoctorProfessionTableViewCell) {
        guard let indexPath = experienceTableView.indexPath(for: cell) else {return}
        self.experienceList.remove(at: indexPath.row)
        self.experienceTableView.reloadData()
        self.updateExperienceListHeight()
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource methods
extension DoctorProfessionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return acceptedInsuranceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorSpecialityCollectionViewCell", for: indexPath) as? DoctorSpecialityCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateWith(item: Array(acceptedInsuranceList)[indexPath.row])
        cell.deleteCompletion = { [weak self] (item) in
            self?.acceptedInsuranceList.remove(item)
            collectionView.reloadData()
            self?.insuranceCollectionView.isHidden = self?.acceptedInsuranceList.count == 0
        }
        
        return cell
    }
}

//MARK: Other methods
extension DoctorProfessionVC {
    
    func initialSetup() {
        experienceList = []
        experienceList.append(DoctorSignUpRequestExperienceDetails())
        experienceTableView.reloadData()
        self.updateExperienceListHeight()
        
        insurancesList = Set(doctorSignUpViewModel.getInsuranceTypeList())
        
        self.loadTermsTextView()
    }
    
    func isValidInformation() -> Bool {
        var errorFound = false
        if professionBioTextView.text == "" {
            AlertManager.showAlert(title: "Profession bio is required")
            errorFound = true
        } else if !isValidExperienceInfo() {
            AlertManager.showAlert(title: "Please check your entered Experience info")
            errorFound = true
        } else if licenceImage == nil {
            AlertManager.showAlert(title: "License photo is required")
            errorFound = true
        } else if isAcceptedAllInsurance && acceptedInsuranceList.count == 0 {
            AlertManager.showAlert(title: "Select minimum 1 insurance")
            errorFound = true
        } else if businessAgreementSelectionView.selectedTag == -1 {
            AlertManager.showAlert(title: "Select business associate agreement")
            errorFound = true
        } else if hipaaAgreementSelectionView.selectedTag == -1 {
            AlertManager.showAlert(title: "Select HIPAA agreement")
            errorFound = true
        } else if gdprLawsSelectionView.selectedTag == -1 {
            AlertManager.showAlert(title: "Select GDPR Laws agreement")
            errorFound = true
        } else if !isTermsSelected {
            AlertManager.showAlert(title: "Select terms and privacy")
            errorFound = true
        }
        
        return !errorFound
    }
    
    func isValidExperienceInfo() -> Bool {
        var isValid = true
        for Experience in experienceList {
            if Experience.establishmentName == nil || Experience.jobTitle == nil || Experience.startDate == nil {
                isValid = false
            }
        }
        return isValid
    }
    
    func loadDummyData() {
        professionBioTextView.text = "Test bio"
        let experience = DoctorSignUpRequestExperienceDetails()
        experience.establishmentName = "test establishment"
        experience.jobTitle = "test title"
        experience.startDate = "2021-11-29"
        experienceList = [experience]
        experienceTableView.reloadData()
        
        licenceImage = UIImage(named: "default_profile")
        
        acceptedInsuranceList = Set(insurancesList.prefix(3))
        insuranceCollectionView.isHidden = false
        insuranceCollectionView.reloadData()
    }
    
    func updateDoctorSignUpRequestDetails() {
        let object = DataManager.shared.doctorSignUpRequestDetails
        object?.professionalBio = professionBioTextView.text ?? nil
        object?.experience = experienceList
        object?.licenseFile = licenceImage?.toBase64()
        let awards = awardsTextView.text.isEmpty ? nil : awardsTextView.text
        object?.awards = awards
        if isAcceptedAllInsurance {
            object?.acceptedInsurance = Array(insurancesList)
        } else {
            object?.acceptedInsurance = Array(acceptedInsuranceList)
        }
    }
    
    func getInsuranceList() -> [IDName] {
        var list = [IDName]()
        let finalList = insurancesList.subtracting(acceptedInsuranceList).sorted()
        for (index, value) in finalList.enumerated() {
            list.append(IDName(id: index, name: value))
        }
        return list
    }
    
    func updateExperienceListHeight() {
        let height = experienceList.count > 1 ? experienceCellHeight : (experienceCellHeight - 44)
        experienceTableViewHeightConstraint.constant = CGFloat(experienceList.count * height)
    }
    
    func loadTermsTextView() {
        let attributedString = NSMutableAttributedString(string: "I agree to the " + "Terms & Conditions" + " and " + "Privacy Policy")
        attributedString.setAttributes([.foregroundColor : UIColor.white,
                                        .font: UIFont.systemFont(ofSize: 18)],
                                       range: NSMakeRange(0, attributedString.string.utf16.count))
        
        if let url = URL(string: "https://www.google.com") {
            attributedString.setAttributes([.link: url,
                                            .font: UIFont.systemFont(ofSize: 18)],
                                           range: NSMakeRange("I agree to the ".utf16.count, "Terms & Conditions".utf16.count))
        }
        
        if let url = URL(string: "https://www.google.com") {
            attributedString.setAttributes([.link: url,
                                            .font: UIFont.systemFont(ofSize: 18)],
                                           range: NSMakeRange("I agree to the ".utf16.count + "Terms & Conditions".utf16.count + " and ".utf16.count, "Privacy Policy".utf16.count))
        }
        termsTextView.attributedText = attributedString
    }
}
