//
//  DoctorProfessionTableViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/30/21.
//

import UIKit

protocol DoctorProfessionTableViewCellDelegate {
    func clickedOnDelete(with cell: DoctorProfessionTableViewCell)
}

class DoctorProfessionTableViewCell: UITableViewCell {
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var establishmentTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var delegate: DoctorProfessionTableViewCellDelegate?
    var object: DoctorSignUpRequestExperienceDetails?
    let timePicker = UIDatePicker()
    var startDate = Date() {
        didSet {
            startDateTextField.text = startDate.dateString(with: "YYYY-MM-dd", local: true)
            object?.startDate = startDateTextField.text
        }
    }
    var endDate = Date() {
        didSet {
            endDateTextField.text = endDate.dateString(with: "YYYY-MM-dd", local: true)
            object?.endDate = endDateTextField.text
        }
    }
    var startIsSelected = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: Action methods
extension DoctorProfessionTableViewCell {
    
    @IBAction func deleteAction(_ sender: Any) {
        delegate?.clickedOnDelete(with: self)
    }
    
    @objc func dateSelectionChanged(sender: UIDatePicker) {
        if startIsSelected {
            startDate = sender.date
        } else {
            endDate = sender.date
        }
    }
}

//MARK: UITextFieldDelegate methods
extension DoctorProfessionTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDateTextField {
            startIsSelected = true
        } else if textField == endDateTextField {
            startIsSelected = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == startDateTextField || textField == endDateTextField {
            return false
        }
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if textField == establishmentTextField {
                object?.establishmentName = updatedText.isEmpty ? nil : updatedText
            } else if textField == jobTitleTextField {
                object?.jobTitle = updatedText.isEmpty ? nil : updatedText
            }
        }
        return true
    }
}

//MARK: UITextViewDelegate methods
extension DoctorProfessionTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: text)
            if textView == jobDescriptionTextView {
                object?.jobDescription = updatedText.isEmpty ? nil : updatedText
            }
        }
        return true
    }
}

//MARK: Other methods
extension DoctorProfessionTableViewCell {
    
    func initialSetup() {
        //inline date selector
        timePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        timePicker.maximumDate = Date()
        timePicker.tintColor = .white
        timePicker.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 200)
        timePicker.backgroundColor = .clear
        timePicker.addTarget(self, action: #selector(dateSelectionChanged), for: .valueChanged)
        
        startDateTextField.delegate = self
        startDateTextField.inputView = timePicker
        endDateTextField.delegate = self
        endDateTextField.inputView = timePicker
    }
    
    func updateWith(object: DoctorSignUpRequestExperienceDetails, profileIndex: Int?) {
        self.object = object
        establishmentTextField.text = object.establishmentName
        jobTitleTextField.text = object.jobTitle
        startDateTextField.text = object.startDate
        endDateTextField.text = object.endDate
        jobDescriptionTextView.text = object.jobDescription
        if let index = profileIndex {
            profileLabel.text = "Experience \(index)"
            profileView.isHidden = false
        } else {
            profileView.isHidden = true
        }
    }
}
