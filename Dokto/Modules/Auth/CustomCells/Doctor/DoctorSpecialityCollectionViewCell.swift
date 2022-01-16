//
//  DoctorSpecialityCollectionViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/29/21.
//

import UIKit

class DoctorSpecialityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var deleteCompletion: ((_ item: String) -> ())?
}

//MARK: Action methods
extension DoctorSpecialityCollectionViewCell {
    
    @IBAction func deleteAction(_ sender: Any) {
        if let text = titleLabel.text {
            deleteCompletion?(text)
        }
    }
}

//MARK: Other methods
extension DoctorSpecialityCollectionViewCell {
    
    func updateWith(item: String) {
        titleLabel.text = item
    }
}
