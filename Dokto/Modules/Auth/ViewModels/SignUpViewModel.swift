//
//  SignUpViewModel.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit

class SignUpViewModel {
    
    var typeList = [RegisterUserTypeDetails]()
    var selectedIndex = 1
}

//MARK: Data related
extension SignUpViewModel {
    
    func loadUserTypes() {
        typeList = []
        typeList.append(RegisterUserTypeDetails(title: "Doctor", icon: "doctor_selection", type: .doctor))
        typeList.append(RegisterUserTypeDetails(title: "Patient", icon: "patient_selection", type: .patient))
    }
}
