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
        removeBackButtonTitle()
    }
    
    @objc open override func leftAction() {
        
    }
    
    func setupUI() {}
    
    func setupObservable() {}
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "." + #function)
    }
}
