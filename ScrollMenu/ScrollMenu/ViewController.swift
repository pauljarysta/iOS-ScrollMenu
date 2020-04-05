//
//  ViewController.swift
//  ScrollMenu
//
//  Created by Paul Jarysta on 17/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScrollMenuDelegate {
	
	@IBOutlet weak var textField: UITextField!
	
	let screenWidth: CGFloat = UIScreen.main.bounds.width
	let screenHeight: CGFloat = UIScreen.main.bounds.height
	
	var scrollMenu: ScrollMenu!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollMenu = ScrollMenu()
		scrollMenu.backgroundColor = UIColor.cyan
		view.addSubview(scrollMenu)
		scrollMenu.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func updateScrollMenuData(date: NSDate) {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE d MMM yyyy"
		let dateString = dateFormatter.string(from: date as Date)
		
		textField.text = dateString
	}
}

