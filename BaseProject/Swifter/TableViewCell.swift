//
//  TableViewCell.swift
//  BaseProject
//
//  Created by MTQ on 4/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
}

extension TableViewCell {
    func updateWithWeather(_ weather: String) {
        label.text = weather
    }
}
