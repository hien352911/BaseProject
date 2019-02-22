//
//  XibViewController.swift
//  BaseProject
//
//  Created by MTQ on 1/4/19.
//  Copyright © 2019 MTQ. All rights reserved.
//

import UIKit

protocol XibViewController {
//    static var className: String { get }
    static func make() -> Self
}

extension XibViewController where Self: UIViewController {
//    static var className: String {
//        return String(describing: self).components(separatedBy: ".").last!
//    }
    static func make() -> Self {
        return self.init(nibName: Self.className, bundle: nil)
    }
}

extension UIViewController: XibViewController {}
