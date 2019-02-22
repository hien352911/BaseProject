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
        setupUI()
        setupObservable()
    }
    
    @objc open override func leftAction() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {}
    
    func setupObservable() {}
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "." + #function)
    }
}
