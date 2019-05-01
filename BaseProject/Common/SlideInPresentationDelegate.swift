//
//  SlideInPresentationDelegate.swift
//  BaseProject
//
//  Created by seesaa on 4/29/19.
//  Copyright © 2019 MTQ. All rights reserved.
//

import UIKit

class SlideInPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}
