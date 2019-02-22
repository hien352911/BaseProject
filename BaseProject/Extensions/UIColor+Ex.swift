//
//  UIColor+Ex.swift
//  BaseProject
//
//  Created by MTQ on 9/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

extension UIColor {
    class var `default`: UIColor {
        return UIColor(hex: 0x18A55D)!
    }
    
    /**
     * return "#xxxxxx", don't handle case alpha # 1
     */
    func hexString() -> String {
        let comps = self.cgColor.components!
        let compsCount = self.cgColor.numberOfComponents
        let r: Int
        let g: Int
        var b: Int
        
        if compsCount == 4 { // RGBA
            r = Int(comps[0] * 255)
            g = Int(comps[1] * 255)
            b = Int(comps[2] * 255)
        } else { // Grayscale
            r = Int(comps[0] * 255)
            g = Int(comps[0] * 255)
            b = Int(comps[0] * 255)
        }
        var hexString: String = "#"
        hexString += String(format: "%02X%02X%02X", r, g, b)
        return hexString
    }
}
