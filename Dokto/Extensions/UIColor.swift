//
//  UIColor.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit

enum ColorName: String {
    case _2F97D3 = "color_2F97D3"
    case _170041 = "color_170041"
    case _A42BAD = "color_A42BAD"
}

extension UIColor {
    
    class func hex(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func named(_ name: ColorName) -> UIColor? {
        return UIColor(named: name.rawValue) ?? .black
    }
}
