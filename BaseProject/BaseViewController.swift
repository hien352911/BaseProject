//
//  BaseViewController.swift
//  BaseProject
//
//  Created by MTQ on 5/15/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func makeBackLeftBarButtonItem() {
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_navbar_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_navbar_back")
        removeBackButtonTitle()
    }
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "." + #function)
    }
}
