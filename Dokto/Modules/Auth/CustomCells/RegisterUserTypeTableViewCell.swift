//
//  RegisterUserTypeTableViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit
import Alamofire

class RegisterUserTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var object: RegisterUserTypeDetails!
    var actionCompletion: ((RegisterUserTypeDetails) -> ())?
}

//MARK: Other methods
extension RegisterUserTypeTableViewCell {
    
    func updateWith(object: RegisterUserTypeDetails) {
        self.object = object
        iconImageView.image = UIImage(named: object.icon)
        titleLabel.text = object.title
        contentsView.backgroundColor = object.color
    }
}
