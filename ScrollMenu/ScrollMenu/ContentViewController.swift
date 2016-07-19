//
//  ContentViewController.swift
//  ScrollMenu
//
//  Created by Paul Jarysta on 18/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit
import MapKit

class ContentViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
		
}
