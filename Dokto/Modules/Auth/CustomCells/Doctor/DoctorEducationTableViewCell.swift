//
//  DoctorEducationTableViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/28/21.
//

import UIKit

protocol DoctorEducationTableViewCellDelegate {
    func clickedOnDelete(with cell: DoctorEducationTableViewCell)
}

class DoctorEducationTableViewCell: UITableViewCell {
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var yearGraduatedTextField: UITextField!
    @IBOutlet weak var certificateImageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    var delegate: DoctorEducationTableViewCellDelegate?
    var object: DoctorSignUpRequestEducationDetails?
    var certificateImage: UIImage? {
        didSet {
            certificateImageView.image = certificateImage
            object?.certificate = certificateImage?.toBase64()
            object?.certificateImage = certificateImage
        }
    }
    let timePicker = UIDatePicker()
    var selectedDate = Date() {
        didSet {
            yearGraduatedTextField.text = selectedDate.dateString(with: "YYYY-MM-dd", local: true)
            object?.year = yearGraduatedTextField.text
        }
    }
    
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
extension DoctorEducationTableViewCell {
    
    @IBAction func deleteAction(_ sender: Any) {
        delegate?.clickedOnDelete(with: self)
    }
    
    @IBAction func certificateAction(_ sender: Any) {
        TaskManager.shared.getPhotoWith(size: CGSize(width: 256, height: 256)) { [weak self] image in
            self?.certificateImage = image
            self?.choosePhotoButton.isHidden = true
            self?.editPhotoButton.isHidden = false
        }
    }
    
    @objc func dateSelectionChanged(sender: UIDatePicker) {
        selectedDate = sender.date
    }
}

//MARK: UITextFieldDelegate methods
extension DoctorEducationTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == yearGraduatedTextField {
            return false
        }
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if textField == collegeTextField {
                object?.college = updatedText.isEmpty ? nil : updatedText
            } else if textField == courseTextField {
                object?.course = updatedText.isEmpty ? nil : updatedText
            }
        }
        return true
    }
}

//MARK: Other methods
extension DoctorEducationTableViewCell {
    
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
        yearGraduatedTextField.delegate = self
        yearGraduatedTextField.inputView = timePicker
    }
    
    func updateWith(object: DoctorSignUpRequestEducationDetails, profileIndex: Int?) {
        self.object = object
        collegeTextField.text = object.college
        courseTextField.text = object.course
        yearGraduatedTextField.text = object.year
        certificateImageView.image = object.certificateImage
        choosePhotoButton.isHidden = object.certificateImage != nil
        editPhotoButton.isHidden = !choosePhotoButton.isHidden
        if let index = profileIndex {
            profileLabel.text = "Profile \(index)"
            profileView.isHidden = false
        } else {
            profileView.isHidden = true
        }
    }
}
