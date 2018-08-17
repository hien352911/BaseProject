//
//  ReachabilityViewController.swift
//  BaseProject
//
//  Created by MTQ on 5/3/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit
import Reachability

class ReachabilityViewController: UIViewController {
    // Phải khai báo reachability ở ngoài func, ko để trong func được
    let reachability = Reachability()!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkIsReachability()
        
        observableReachability()
    }
    
    func checkIsReachability() {
        if Utilities.shared.isReachability {
            print("Co manga")
        } else {
            print("Mat mang")
        }
    }

    func observableReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

}
