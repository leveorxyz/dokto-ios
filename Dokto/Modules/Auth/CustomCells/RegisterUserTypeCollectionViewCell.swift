//
//  RegisterUserTypeCollectionViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit
import Alamofire

class RegisterUserTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeButton: UIButton!
    
    var object: RegisterUserTypeDetails!
    var actionCompletion: ((RegisterUserTypeDetails) -> ())?
}

//MARK: Other methods
extension RegisterUserTypeCollectionViewCell {
    
    @IBAction func buttonAction(_ sender: Any) {
        actionCompletion?(object)
    }
}

//MARK: Other methods
extension RegisterUserTypeCollectionViewCell {
    
    func updateWith(object: RegisterUserTypeDetails) {
        self.object = object
        typeButton.setImage(UIImage(named: object.icon), for: .normal)
    }
}
