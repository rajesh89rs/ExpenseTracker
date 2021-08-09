//
//  ColorUtils.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 09/08/21.
//

import Foundation
import UIKit

extension UIColor {
    
    class var greenLight: UIColor {
        return UIColor.hexStringToUIColor("#008540")
    }
    
    class func hexStringToUIColor (_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        
        if cString.hasPrefix("#") {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
