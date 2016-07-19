//
//  ScrollMenu.swift
//  ScrollMenu
//
//  Created by Paul Jarysta on 17/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

class ScrollMenu: UIView {
	
	@IBOutlet weak var viewMenu: UIView!
	@IBOutlet weak var viewHeaderMenu: UIView!
	@IBOutlet weak var actionMenu: NSLayoutConstraint!
	
	let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
	let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
	
	var view:UIView!
	
	let contentHeight: CGFloat = 216
	
	func loadViewFromNib() -> UIView {
//		let view = UINib.init(nibName: String("ScrollMenu"), bundle: nil).instantiateWithOwner(self, options: nil).last as! ScrollMenu
		// return (NSBundle.mainBundle().loadNibNamed("ScrollMenu", owner: self, options: nil).first as! ScrollMenu)
		
		let bundle = NSBundle(forClass: self.dynamicType)
		let nib = UINib(nibName: "ScrollMenu", bundle: bundle)
		let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
		
		return view
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	func setup() {
//		viewMenu = loadViewFromNib()
//		viewMenu.frame = CGRectMake(0, screenHeight - 200, screenWidth, 200)
//		let view1 = loadViewFromNib()
//		view1.frame = CGRectMake(0, screenHeight - 200, screenWidth, 200)
//		addSubview(view1)
		
		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
		
		addSubview(view)
	}
	
	
	@IBAction func actionMenu(sender: UIButton) {
		
		
	}
	
}
