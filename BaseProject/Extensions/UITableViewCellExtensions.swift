//
//  UITableViewCellExtensions.swift
//  business-card
//
//  Created by MTQ on 12/23/19.
//  Copyright © 2019 s-usui. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func cellInstance(_ nibName: String? = nil, bundle: Bundle = Bundle.main) -> UITableViewCell? {
        let name = nibName ?? identifier
        let cells = bundle.loadNibNamed(name, owner: self, options: nil)
        let cell = cells?.first as? UITableViewCell
        return cell
    }
}
