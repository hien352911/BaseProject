//
//  UIApplication+Ex.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

extension UIApplication {
    func rootWindow() -> UIWindow? {
        if !WindowManager.shared.progressWindow.isHidden {
            return WindowManager.shared.progressWindow
        }
        return self.keyWindow
    }
    
    func showActivity(isShow: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isShow
        }
    }
}
