//
//  UINavigationBar+Ex.swift
//  BaseProject
//
//  Created by MTQ on 9/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

extension UINavigationBar {
    /// Set Navigation Bar title color.
    ///
    /// - Parameters:
    ///   - color: title text color (default is .black).
    public func setTitleColor(_ color: UIColor) {
        var attrs = [NSAttributedStringKey: Any]()
        attrs[.foregroundColor] = color
        titleTextAttributes = attrs
    }
}
