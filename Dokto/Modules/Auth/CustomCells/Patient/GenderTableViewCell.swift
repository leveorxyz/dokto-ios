//
//  GenderTableViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/20/21.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: Update related methods
extension GenderTableViewCell {
    
    func updateWith(object: GenderType, isSelected: Bool) {
        titleLabel.text = object.rawValue
        selectionImageView.tintColor = isSelected ? .named(._A42BAD) : .white.withAlphaComponent(0.5)
        selectionImageView.image = UIImage(named: isSelected ? "radio_filled" : "radio_empty")
    }
    
    func updateWith(object: LanguageType, isSelected: Bool) {
        titleLabel.text = object.rawValue
        titleLabel.textColor = .white
        selectionImageView.tintColor = isSelected ? .named(._A42BAD) : .white.withAlphaComponent(0.5)
        selectionImageView.image = UIImage(named: isSelected ? "check_filled" : "check_blank")
    }
}
