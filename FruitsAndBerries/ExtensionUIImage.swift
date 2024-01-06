//
//  ExtensionUIImage.swift
//  iOS-Test
//
//  Created by Vlad on 1/5/24.
//

import Foundation
import UIKit

public extension UIImageView {
    //start animation
    func rotate(onTime: Double) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = onTime
        rotation.repeatCount = 100
        layer.add(rotation, forKey: "spin")
    }
    
    //stop animation
    func stopRotate() {
        layer.removeAllAnimations()
    }
}
