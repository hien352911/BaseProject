//
//  Window.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ProgressViewController: UIViewController, NVActivityIndicatorViewable {
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

class WindowManager: NSObject {
    var canHideProgress = true
    let progressController = ProgressViewController()
    static let shared = WindowManager()
    /**
     * This is progress window. Will show overlay all screen in app.
     */
    lazy var progressWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.isOpaque = true
        window.rootViewController = self.progressController
//        window.rootViewController?.setupNavigationDefault()
        window.rootViewController?.navigationController?.navigationBar.isTranslucent = true
        window.windowLevel = WindowManager.currentWindowLevel() + 0.1
        return window
    }()
    
    /**
     * Get window level of visible window displaying in app
     */
    class func currentWindowLevel() -> CGFloat {
        if let window = UIApplication.shared.keyWindow {
            return window.windowLevel
        }
        return UIWindowLevelStatusBar
    }
    
    
    /**
     * Call this to show waiting progress view overlay all screen in app.
     */
    func showProgressView(rootView: UIView? = nil) {
        DispatchQueue.main.async {
            AppDelegate.shared.window?.isUserInteractionEnabled = false
            self.progressWindow.windowLevel = WindowManager.currentWindowLevel() + 0.1
            self.progressWindow.isHidden = false
            let size = CGSize(width: 30, height: 30)
            
            let color = UIColor(hex: 0x720999)
//            self.progressController.view.backgroundColor = .red
            self.progressController.startAnimating(size,
                                                   message: "",
                                                   type: .ballPulse,
                                                   color: color, backgroundColor: UIColor.clear)
        }
    }
    
    /**
     * Call anywhere when you want close waiting proress view
     */
    func hideProgressView(isSuccess: Bool = true) {
        if !canHideProgress {
            return
        }
        //Invoke code on main thread
        DispatchQueue.main.async {
            if self.progressWindow.isHidden == false {
                AppDelegate.shared.window?.isUserInteractionEnabled = true
                self.progressController.stopAnimating()
                self.progressWindow.isHidden = true
            }
        }
    }
}
