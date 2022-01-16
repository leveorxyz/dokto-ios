//
//  SignUpViewModel.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit

class SignUpViewModel {
    
    var typeList = [RegisterUserTypeDetails]()
    var selectedIndex = 0
}

//MARK: Data related
extension SignUpViewModel {
    
    func loadUserTypes() {
        typeList = []
        typeList.append(RegisterUserTypeDetails(title: "Patient", icon: "register_patient", color: .hex("5D4D7A"), type: .patient))
        typeList.append(RegisterUserTypeDetails(title: "Doctor", icon: "register_doctor", color: .hex("7517D5"), type: .doctor))
        typeList.append(RegisterUserTypeDetails(title: "Clinic", icon: "register_clinic", color: .hex("00695C"), type: .clinic))
        typeList.append(RegisterUserTypeDetails(title: "Pharmacy", icon: "register_pharmacy", color: .hex("03A9F4"), type: .pharmacy))
    }
}
