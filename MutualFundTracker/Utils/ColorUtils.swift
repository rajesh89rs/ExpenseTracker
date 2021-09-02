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
    
    // Graphics: active icons
    // Text: dark text (all headings)
    class var gray90: UIColor {
        return UIColor.hexStringToUIColor("#1A1A1A")
    }
    
    // Graphics: n/a
    // Text: n/a
    class var gray80: UIColor {
        return UIColor.hexStringToUIColor("#333333")
    }
    
    // Graphics: toast background
    // Text: body text, caption, overline
    class var gray70: UIColor {
        return UIColor.hexStringToUIColor("#4d4d4d")
    }
    
    // Graphics: input fields icons, elements
    // Text: disabled
    class var gray60: UIColor {
        return UIColor.hexStringToUIColor("#666666")
    }
    
    // Graphics: n/a
    // Text: light text
    class var gray50: UIColor {
        // Use .gray70 color if Increase Contrast enabled
        if UIAccessibility.isDarkerSystemColorsEnabled {
            return UIColor.hexStringToUIColor("#4d4d4d")
        }
        return UIColor.hexStringToUIColor("#808080")
    }
    
    // Graphics: n/a
    // Text: n/a
    class var gray40: UIColor {
        return UIColor.hexStringToUIColor("#999999")
    }
    
    // Graphics: dark lines, inputs, outline buttons, inactive icons
    // Text: n/a
    class var gray30: UIColor {
        return UIColor.hexStringToUIColor("#B3B3B3")
    }
    
    // Graphics: borders, dividers
    // Text: n/a
    class var gray20: UIColor {
        return UIColor.hexStringToUIColor("#CCCCCC")
    }
    
    // Graphics: disabled background
    // Text: n/a
    class var gray10: UIColor {
        return UIColor.hexStringToUIColor("#E6E6E6")
    }
    
    // Graphics: background areas
    // Text: n/a
    class var gray5: UIColor {
        return UIColor.hexStringToUIColor("#F2F2F2")
    }
    
}
