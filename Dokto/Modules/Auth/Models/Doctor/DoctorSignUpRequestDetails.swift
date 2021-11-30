//
//  DoctorSignUpRequestDetails.swift
//  Dokto
//
//  Created by Rupak on 11/26/21.
//

import UIKit

class DoctorSignUpRequestDetails: Codable {
    var acceptedInsurance : [String]?
    var awards : String?
    var city : String?
    var contactNo : String?
    var country : String?
    var dateOfBirth : String?
    var education : [DoctorSignUpRequestEducationDetails]?
    var email : String?
    var experience : [DoctorSignUpRequestExperienceDetails]?
    var facebookUrl : String?
    var fullName : String?
    var gender : String?
    var identificationNumber : String?
    var identificationPhoto : String?
    var identificationType : String?
    var language : [String]?
    var licenseFile : String?
    var linkedinUrl : String?
    var password : String?
    var professionalBio : String?
    var profilePhoto : String?
    var specialty : [String]?
    var state : String?
    var street : String?
    var twitterUrl : String?
    var zipCode : String?
    
    enum CodingKeys: String, CodingKey {
        case acceptedInsurance = "accepted_insurance"
        case awards = "awards"
        case city = "city"
        case contactNo = "contact_no"
        case country = "country"
        case dateOfBirth = "date_of_birth"
        case education = "education"
        case email = "email"
        case experience = "experience"
        case facebookUrl = "facebook_url"
        case fullName = "full_name"
        case gender = "gender"
        case identificationNumber = "identification_number"
        case identificationPhoto = "identification_photo"
        case identificationType = "identification_type"
        case language = "language"
        case licenseFile = "license_file"
        case linkedinUrl = "linkedin_url"
        case password = "password"
        case professionalBio = "professional_bio"
        case profilePhoto = "profile_photo"
        case specialty = "specialty"
        case state = "state"
        case street = "street"
        case twitterUrl = "twitter_url"
        case zipCode = "zip_code"
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        acceptedInsurance = try? values?.decodeIfPresent([String].self, forKey: .acceptedInsurance)
        awards = try? values?.decodeIfPresent(String.self, forKey: .awards)
        city = try? values?.decodeIfPresent(String.self, forKey: .city)
        contactNo = try? values?.decodeIfPresent(String.self, forKey: .contactNo)
        country = try? values?.decodeIfPresent(String.self, forKey: .country)
        dateOfBirth = try? values?.decodeIfPresent(String.self, forKey: .dateOfBirth)
        education = try? values?.decodeIfPresent([DoctorSignUpRequestEducationDetails].self, forKey: .education)
        email = try? values?.decodeIfPresent(String.self, forKey: .email)
        experience = try? values?.decodeIfPresent([DoctorSignUpRequestExperienceDetails].self, forKey: .experience)
        facebookUrl = try? values?.decodeIfPresent(String.self, forKey: .facebookUrl)
        fullName = try? values?.decodeIfPresent(String.self, forKey: .fullName)
        gender = try? values?.decodeIfPresent(String.self, forKey: .gender)
        identificationNumber = try? values?.decodeIfPresent(String.self, forKey: .identificationNumber)
        identificationPhoto = try? values?.decodeIfPresent(String.self, forKey: .identificationPhoto)
        identificationType = try? values?.decodeIfPresent(String.self, forKey: .identificationType)
        language = try? values?.decodeIfPresent([String].self, forKey: .language)
        licenseFile = try? values?.decodeIfPresent(String.self, forKey: .licenseFile)
        linkedinUrl = try? values?.decodeIfPresent(String.self, forKey: .linkedinUrl)
        password = try? values?.decodeIfPresent(String.self, forKey: .password)
        professionalBio = try? values?.decodeIfPresent(String.self, forKey: .professionalBio)
        profilePhoto = try? values?.decodeIfPresent(String.self, forKey: .profilePhoto)
        specialty = try? values?.decodeIfPresent([String].self, forKey: .specialty)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
        street = try? values?.decodeIfPresent(String.self, forKey: .street)
        twitterUrl = try? values?.decodeIfPresent(String.self, forKey: .twitterUrl)
        zipCode = try? values?.decodeIfPresent(String.self, forKey: .zipCode)
    }
}

class DoctorSignUpRequestExperienceDetails: NSObject, Codable {
    var doctorInfo : String?
    var endDate : String?
    var establishmentName : String?
    var jobDescription : String?
    var jobTitle : String?
    var startDate : String?
    
    enum CodingKeys: String, CodingKey {
        case doctorInfo = "doctor_info"
        case endDate = "end_date"
        case establishmentName = "establishment_name"
        case jobDescription = "job_description"
        case jobTitle = "job_title"
        case startDate = "start_date"
    }
    
    override init() {}
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        doctorInfo = try? values?.decodeIfPresent(String.self, forKey: .doctorInfo)
        endDate = try? values?.decodeIfPresent(String.self, forKey: .endDate)
        establishmentName = try? values?.decodeIfPresent(String.self, forKey: .establishmentName)
        jobDescription = try? values?.decodeIfPresent(String.self, forKey: .jobDescription)
        jobTitle = try? values?.decodeIfPresent(String.self, forKey: .jobTitle)
        startDate = try? values?.decodeIfPresent(String.self, forKey: .startDate)
    }
}

class DoctorSignUpRequestEducationDetails: NSObject, Codable {
    var certificate : String?
    var college : String?
    var course : String?
    var doctorInfo : String?
    var year : String?
    var certificateImage : UIImage?
    
    enum CodingKeys: String, CodingKey {
        case certificate = "certificate"
        case college = "college"
        case course = "course"
        case doctorInfo = "doctor_info"
        case year = "year"
    }
    override init() {}
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        certificate = try? values?.decodeIfPresent(String.self, forKey: .certificate)
        college = try? values?.decodeIfPresent(String.self, forKey: .college)
        course = try? values?.decodeIfPresent(String.self, forKey: .course)
        doctorInfo = try? values?.decodeIfPresent(String.self, forKey: .doctorInfo)
        year = try? values?.decodeIfPresent(String.self, forKey: .year)
    }
}
