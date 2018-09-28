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
    
    @IBAction func postItemForUse(_ sender: UIButton) {
        performSegue(withIdentifier: "PostSegue", sender: 1)
    }
    
    @IBAction func postItemRequest(_ sender: UIButton) {
        performSegue(withIdentifier: "PostSegue", sender: 2)
    }
    
    @IBAction func allItems(_ sender: UIButton) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PostSegue") {
            let dest = segue.destination as! PostViewController
            let postType = sender as! Int
            if postType == 1 {
                dest.isLending = true
                dest.isAvailable = true
            } else if postType == 2 {
                dest.isLending = false
                dest.isAvailable = false
            }
        }
    }
}
