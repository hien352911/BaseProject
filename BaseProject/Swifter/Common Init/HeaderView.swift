//
//  HeaderView.swift
//  BaseProject
//
//  Created by MTQ on 3/10/19.
//  Copyright © 2019 MTQ. All rights reserved.
//

import UIKit

class HeaderView: UIView {
	
	@IBOutlet private var contentView: UIView!

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed("HeaderView", owner: self)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}

}
