//
//  UIView.swift
//  BaseProject
//
//  Created by MTQ on 4/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

extension UIView {
    func roundView() {
        let minSize = min(bounds.width, bounds.height)
        layer.cornerRadius = minSize / 2
        layer.masksToBounds = true
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
