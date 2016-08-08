//
//  ScrollMenu.swift
//  ScrollMenu
//
//  Created by Paul Jarysta on 17/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

protocol ScrollMenuDelegate {
	func updateScrollMenuData(date: NSDate)
}

class ScrollMenu: UIView {
	
	@IBOutlet weak var toolbar: UIToolbar!
	
	@IBOutlet weak var itemButton: UIButton!
	
	@IBOutlet weak var datePicker: UIDatePicker!
	
	let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
	let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height

	var delegate: ScrollMenuDelegate?

	var view: UIView!

	var heightMenu: CGFloat = 200.0
	
	override init(frame: CGRect) {

		if frame == CGRectZero {
			super.init(frame: CGRect(x: 0, y: screenHeight - heightMenu, width: screenWidth, height: heightMenu))
		} else {
			super.init(frame: frame)
		}
		setup()
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		setup()
	}
	
	func setup() {

		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		addSubview(view)

		initMenu()
		
		initDatePicker()

		initGesture()
	}
	
	// MARK: - Init View
	func loadViewFromNib() -> UIView {
		
		let bundle = NSBundle(forClass:self.dynamicType)
		let nib = UINib(nibName: "ScrollMenu", bundle: bundle)
		let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
		
		return view
	}
	
	// MARK: - Init Menu
	func initMenu() {
		itemButton.selected = false
		let maxTranslation = self.screenHeight + (self.frame.height - self.toolbar.frame.height)
		let centerView = maxTranslation - (self.frame.height / 2)
		self.center.y = centerView
	}
	
	// MARK: - Init DatePicker
	func initDatePicker() {
		datePicker.datePickerMode = UIDatePickerMode.Date
	}
	
	// MARK: - Init Gesture
	func initGesture() {
		let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanOnView(_:)))
		self.addGestureRecognizer(pan)
	}
	
	func didPanOnView(sender: UIPanGestureRecognizer) {
		
		let translation = sender.translationInView(self)

		if let senderView = sender.view {
			
			let newSenderView = senderView.frame.origin.y + senderView.frame.height + translation.y
			
			let maxTranslation = screenHeight + (senderView.frame.height - toolbar.frame.height)
			
			let minTranslation = screenHeight
			
			var newSenderViewCenter = senderView.center.y + translation.y
			
			if newSenderView < minTranslation {
				newSenderViewCenter = screenHeight - (senderView.frame.height / 2)
			} else if newSenderView > maxTranslation {
				newSenderViewCenter = maxTranslation - (senderView.frame.height / 2)
			}
			
			if sender.state == UIGestureRecognizerState.Ended {
			
				if (maxTranslation - newSenderView) > (maxTranslation - minTranslation) / 2 {
					
					// Open
					UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
						
						newSenderViewCenter = self.screenHeight - (senderView.frame.height / 2)
						
						}, completion: { finished in
							self.itemButton.setTitle("Close", forState: .Normal)
							self.itemButton.selected = true
					})
				} else {
					
					// Close
					UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
						
						newSenderViewCenter = maxTranslation - (senderView.frame.height / 2)
						
						}, completion: { finished in
							self.delegate?.updateScrollMenuData(self.datePicker.date)
							self.itemButton.setTitle("Open", forState: .Normal)
							self.itemButton.selected = false
					})
				}
			}
			senderView.center.y =  newSenderViewCenter
			sender.setTranslation(CGPointZero, inView: self)
		}
	}


	@IBAction func actionMenu(sender: UIButton) {
		
		if (sender.selected == false) {
			
			// Open
			UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
				
				let centerView = self.screenHeight - (self.frame.height / 2)
				
				self.center.y = centerView
				
				}, completion: { finished in
					sender.selected = true
					self.itemButton.setTitle("Close", forState: .Normal)
			})
			
		} else {
			
			// Close
			UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
				
				let maxTranslation = self.screenHeight + (self.frame.height - self.toolbar.frame.height)
				
				let centerView = maxTranslation - (self.frame.height / 2)
				
				self.center.y = centerView
				
				}, completion: { finished in
					sender.selected = false
					self.itemButton.setTitle("Open", forState: .Normal)
					self.delegate?.updateScrollMenuData(self.datePicker.date)
			})
		}
	}
}
