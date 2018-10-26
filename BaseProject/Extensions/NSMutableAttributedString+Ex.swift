//
//  NSMutableAttributedString+Ex.swift
//  BaseProject
//
//  Created by MTQ on 10/23/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    public func setStyleText(textToFind: String, font: UIFont) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.font, value: font, range: foundRange)
        }
        
    }
    public func setTextColor(textToFind: String, textColor: UIColor) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: textColor, range: foundRange)
        }
    }
    
    public func setBackgroundColor(textToFind: String, backgroundColor: UIColor) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.backgroundColor, value: backgroundColor, range: foundRange)
        }
    }
    public func setAsLink(textToFind: String, linkURL :String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
    
    public func setUnderline(textToFind: String) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: foundRange)
        }
    }
}
