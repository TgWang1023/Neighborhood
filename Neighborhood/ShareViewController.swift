//
//  ShareViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/24/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import MapKit

class ShareViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func postItemForUse(_ sender: UIButton) {
        performSegue(withIdentifier: "PostSegue", sender: nil)
    }
    
    @IBAction func postItemRequest(_ sender: UIButton) {
        performSegue(withIdentifier: "PostSegue", sender: nil)
    }
    
    @IBAction func allPostedItems(_ sender: UIButton) {
        performSegue(withIdentifier: "ItemsSegue", sender: nil)
    }
    
    @IBAction func allItemRequests(_ sender: Any) {
        performSegue(withIdentifier: "ItemsSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
