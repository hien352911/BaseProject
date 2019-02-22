//
//  BaseNavigationController.swift
//  BaseProject
//
//  Created by MTQ on 11/13/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.lightGray
        navigationBar.barTintColor = UIColor.clear
        navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_navbar_back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_navbar_back")
        navigationBar.setTitleColor(UIColor.default)
        
    }
}
