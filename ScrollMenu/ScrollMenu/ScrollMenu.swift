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
	
	let screenWidth: CGFloat = UIScreen.main.bounds.width
	let screenHeight: CGFloat = UIScreen.main.bounds.height

	var delegate: ScrollMenuDelegate?

	var view: UIView!

	var heightMenu: CGFloat = 200.0
	
	override init(frame: CGRect) {

		if frame == .zero {
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
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(view)

		initMenu()
		
		initDatePicker()

		initGesture()
	}
	
	// MARK: - Init View
	func loadViewFromNib() -> UIView {
		
		let bundle = Bundle(for:type(of: self))
		let nib = UINib(nibName: "ScrollMenu", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		
		return view
	}
	
	// MARK: - Init Menu
	func initMenu() {
		itemButton.isSelected = false
		let maxTranslation = self.screenHeight + (self.frame.height - self.toolbar.frame.height)
		let centerView = maxTranslation - (self.frame.height / 2)
		self.center.y = centerView
	}
	
	// MARK: - Init DatePicker
	func initDatePicker() {
		datePicker.datePickerMode = UIDatePicker.Mode.date
	}
	
	// MARK: - Init Gesture
	func initGesture() {
		let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanOnView(sender: )))
		self.addGestureRecognizer(pan)
	}
	
	@objc func didPanOnView(sender: UIPanGestureRecognizer) {
		
		let translation = sender.translation(in: self)

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
			
			if sender.state == UIGestureRecognizer.State.ended {
			
				if (maxTranslation - newSenderView) > (maxTranslation - minTranslation) / 2 {
					
					// Open
					UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
						
						newSenderViewCenter = self.screenHeight - (senderView.frame.height / 2)
						
						}, completion: { finished in
							self.itemButton.setTitle("Close", for: .normal)
							self.itemButton.isSelected = true
					})
				} else {
					
					// Close
					UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
						
						newSenderViewCenter = maxTranslation - (senderView.frame.height / 2)
						
						}, completion: { finished in
							self.delegate?.updateScrollMenuData(date: self.datePicker!.date as NSDate)
							self.itemButton.setTitle("Open", for: .normal)
							self.itemButton.isSelected = false
					})
				}
			}
			senderView.center.y =  newSenderViewCenter
			sender.setTranslation(.zero, in: self)
		}
	}


	@IBAction func actionMenu(sender: UIButton) {
		
		if (sender.isSelected == false) {
			
			// Open
			UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
				
				let centerView = self.screenHeight - (self.frame.height / 2)
				
				self.center.y = centerView
				
				}, completion: { finished in
					sender.isSelected = true
					self.itemButton.setTitle("Close", for: .normal)
			})
			
		} else {
			
			// Close
			UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
				
				let maxTranslation = self.screenHeight + (self.frame.height - self.toolbar.frame.height)
				
				let centerView = maxTranslation - (self.frame.height / 2)
				
				self.center.y = centerView
				
				}, completion: { finished in
					sender.isSelected = false
					self.itemButton.setTitle("Open", for: .normal)
					self.delegate?.updateScrollMenuData(date: (self.datePicker?.date)! as NSDate)
			})
		}
	}
}
