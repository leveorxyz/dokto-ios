//
//  Date.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit

extension Date {
    
    func dateString(with format: String, local: Bool,_ showExtension: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        if !local{
            dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        } else {
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        }
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        var dateString = dateFormatter.string(from: self)
        if !showExtension {
            dateString = dateString.replacingOccurrences(of: " AM", with: "").replacingOccurrences(of: " PM", with: "")
        }
        return dateString
    }
    
    func byAdding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? Date()
    }
}
