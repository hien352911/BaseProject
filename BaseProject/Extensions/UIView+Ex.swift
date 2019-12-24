//
//  UIView.swift
//  BaseProject
//
//  Created by MTQ on 4/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

/**
 layer.shadowColor = UIColor.black.cgColor
 layer.shadowRadius = 12
 layer.shadowOpacity = 0.15
 layer.shadowOffset = CGSize(width: 0, height: 8)
 */

extension UIView {
    func rounded() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
    }
    
    func border(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func cornerRadius(corner: CGFloat) {
        layer.cornerRadius = corner
        layer.masksToBounds = true
    }
}
