//
//  RegisterUserTypeDetails.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit

enum UserType {
    case doctor, patient, none
}

struct RegisterUserTypeDetails {
    var title: String?
    var icon: String = ""
    var type: UserType = .patient
}
