//
//  ShareViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/24/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShareViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager!
    let manager = CLLocationManager()
    let regionRadius: CLLocationDistance = 5000

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func postItemButtonPressed(_ sender: UIButton){
//        ShareModel.addNewShare(newShare: ["item": , "lending": , "isAvailable": , "description": , "lender": LoggedInUser.shared.id], completionHandler: {
//            data, response, error in
//            do {
//                if let newShare = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                    DispatchQueue.main.async {
//
//                    }
//                }
//            } ctach {
//                print("Error in ShareVC, addNewShare().")
//            }
//        })
    }
    
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
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
