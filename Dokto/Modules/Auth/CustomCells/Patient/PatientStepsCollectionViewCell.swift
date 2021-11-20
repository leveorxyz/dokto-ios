//
//  PatientStepsCollectionViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/19/21.
//

import UIKit

class PatientStepsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}

extension PatientStepsCollectionViewCell {
    
    func updateWith(item: String, index: Int, isCompleted: Bool) {
        titleLabel.text = item
        numberLabel.text = "\(index + 1)"
        if isCompleted {
            numberLabel.backgroundColor = .named(._A42BAD)
            titleLabel.textColor = .black
        } else {
            numberLabel.backgroundColor = .gray
            titleLabel.textColor = .gray
        }
        numberLabel.layer.masksToBounds = true
    }
}
