//
//  ExtensionUIColor.swift
//  iOS-Test
//
//  Created by Vlad on 1/5/24.
//

import Foundation
import UIKit

extension UIColor {
    //convert hex to uicolor
    convenience init(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255, blue: CGFloat(rgbValue & 0x0000FF) / 255, alpha: CGFloat(1.0))
    }
}
