//
//  ViewController.swift
//  ScrollMenu
//
//  Created by Paul Jarysta on 17/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit
import MapKit
import AudioToolbox

class ViewController: UIViewController, ScrollMenuDelegate {
	
	// Remove
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var toolBar: UIToolbar!
	@IBOutlet weak var actionItemMenu: UIBarButtonItem!
	@IBOutlet weak var actionMenu: UIButton!
	@IBOutlet weak var viewHeaderMenu: UIView!
	@IBOutlet weak var viewMenu: UIView!
	
	@IBOutlet weak var constraintBottomMenu: NSLayoutConstraint!
	@IBOutlet weak var constraintBottomContentView: NSLayoutConstraint!
	
	// Keep
	
	@IBOutlet weak var textField: UITextField!
	
	let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
	let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
	
	var scrollMenu: ScrollMenu!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollMenu = ScrollMenu()
		scrollMenu.backgroundColor = UIColor.cyanColor()
		view.addSubview(scrollMenu)
		scrollMenu.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func customView() {
		toolBar.barTintColor = UIColor.darkBlue()
		toolBar.translucent = false
		toolBar.opaque = true
		
		constraintBottomContentView.constant = getHeightHeaderMenuView()
		
		let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.didPanOnMenuView(_:)))
		viewMenu.addGestureRecognizer(pan)
		
		let touch = UITapGestureRecognizer(target: self, action: #selector(ViewController.didDetectTouch(_:)))
		touch.numberOfTapsRequired = 1
		containerView.addGestureRecognizer(touch)
	}
	
	func initMenu() {
		self.constraintBottomMenu.constant = -(self.getHeightMenuView() - self.getHeightHeaderMenuView())
		self.actionMenu.setTitle("Open", forState: .Normal)
		self.actionMenu.selected = true
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInView(self.view)
//			print("Location: \(location)")
		}
	}
	
	func didDetectTouch(sender: UIPanGestureRecognizer) {
		
		print(actionMenu.selected)
		if actionMenu.selected == false {
			initMenu()
		}
		
	}
	
	func didPanOnMenuView(sender: UIPanGestureRecognizer) {
		
		let translation = sender.translationInView(viewMenu)
		
		if let senderMenuView = sender.view {

			print("####")
			
			let newSenderMenuView = senderMenuView.frame.origin.y + senderMenuView.frame.height + translation.y
			print("newSenderViewBottom = \(newSenderMenuView)")
			
			let menuViewMaxTranslation = view.frame.height + (viewMenu.frame.height - viewHeaderMenu.frame.height)
			print("menuViewMaxTranslation = \(menuViewMaxTranslation)")
			
			let menuViewMinTranslation = view.bounds.height
			print("menuViewMinTranslation = \(menuViewMinTranslation)")
			
			var newSenderViewCenter = senderMenuView.center.y + translation.y
			print("senderView.center.y // newSenderViewCenter = \(senderMenuView.center.y) // \(newSenderViewCenter)")
			
			if newSenderMenuView < menuViewMinTranslation {
				newSenderViewCenter = view.bounds.height - (senderMenuView.bounds.height / 2)
			}  else if newSenderMenuView > menuViewMaxTranslation {
				newSenderViewCenter = menuViewMaxTranslation - (senderMenuView.bounds.height / 2)
			}
			
			print("---")
			print("menuViewMaxTranslation - menuViewMinTranslation = \(menuViewMaxTranslation - menuViewMinTranslation)")
			print("menuViewMaxTranslation - newSenderMenuView = \(menuViewMaxTranslation - newSenderMenuView)")
			print("---")
			
			
			
			print("newSenderViewCenter x2 = \(newSenderViewCenter)")
			senderMenuView.center.y = newSenderViewCenter
	
			print(menuViewMaxTranslation - newSenderMenuView)
			print("newSenderMenuView = \(newSenderMenuView)")
			
			if sender.state == UIGestureRecognizerState.Ended {
				
				print("### \(menuViewMaxTranslation - newSenderMenuView)")
				
				if (menuViewMaxTranslation - newSenderMenuView) > (menuViewMaxTranslation - menuViewMinTranslation) / 2 {

					// Open
					UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {

						senderMenuView.center.y = 559
						self.constraintBottomMenu.constant = 0

						}, completion: { finished in
							// Do someting when is open
							self.actionMenu.setTitle("Close", forState: .Normal)
							// AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
					})
					self.actionMenu.selected = false
				} else {
					
					// Close
					UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
						
						senderMenuView.center.y = 723
						self.constraintBottomMenu.constant = -(self.getHeightMenuView() - self.getHeightHeaderMenuView())
						
						}, completion: { finished in
							// Do something when is close
							self.actionMenu.setTitle("Open", forState: .Normal)
					})
					self.actionMenu.selected = true
				}
				
			}
			
			sender.setTranslation(CGPointZero, inView: self.view)

		}

	}
	
	func updateScrollMenuData(date: NSDate) {

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE d MMM yyyy"
		let dateString = dateFormatter.stringFromDate(date)
		
		textField.text = dateString
	}
	
	func getHeightMenuView() -> CGFloat {
		return viewMenu.bounds.height
	}
	
	func getHeightHeaderMenuView() -> CGFloat {
		return viewHeaderMenu.bounds.height
	}
	
	func doAnimationConstraint(duration: NSTimeInterval = 1.5, delay: NSTimeInterval = 0.0, options: UIViewAnimationOptions = .CurveEaseInOut, constraint: NSLayoutConstraint, constant: CGFloat) {
		UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
			constraint.constant = constant

			}, completion: { finished in
		})
	}
	
	@IBAction func actionMenu(sender: UIButton) {
		
		print(sender.selected)
		//		sender.selected = !sender.selected
		
		if (sender.selected == false) {
			actionMenu.setTitle("Open", forState: .Normal)
			doAnimationConstraint(constraint: constraintBottomMenu, constant: -(getHeightMenuView() - getHeightHeaderMenuView()))
			sender.selected = true
		} else if (sender.selected == true) {
			actionMenu.setTitle("Close", forState: .Normal)
			doAnimationConstraint(constraint: constraintBottomMenu, constant: 0)
			// AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
			sender.selected = false
		}
		
	}
	

}

