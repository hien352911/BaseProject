//
//  BaseTableViewController.swift
//  BaseProject
//
//  Created by MTQ on 9/25/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    @objc open override func leftAction() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeBackButtonTitle()
    }
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "." + #function)
    }
}
