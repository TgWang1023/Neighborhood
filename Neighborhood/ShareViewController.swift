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
    
    var mapData = [NSDictionary]()
    
    var locationManager: CLLocationManager!
    let manager = CLLocationManager()
    let regionRadius: CLLocationDistance = 500

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
        let lat = (LoggedInUser.shared.latitude as NSString).doubleValue
        let lon = (LoggedInUser.shared.longitude as NSString).doubleValue
        let user_location: CLLocation = CLLocation(latitude: lat, longitude: lon)
        let user_coordinate = MKCoordinateRegion(center: user_location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(user_coordinate, animated: true)
        mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMapData()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        let pinImage = UIImage(named: "sharePin")
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.image = resizedImage
            annotationView!.canShowCallout = true
            let btn = UIButton(type: .infoDark)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let share = view.annotation as! ShareAnnotation
        print("accessory button tapped")
//        performSegue(withIdentifier: "EventDetailsSegue", sender: event)
    }
    
    func fetchMapData(){
        mapData = []
        ShareModel.getAllShares(completionHandler:{
            data, response, error in
            do {
                if let shares = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    let share = shares["data"]
                    if (share as! NSArray).count > 0{
                        for eachShare in share as! NSArray{
                            self.mapData.append(eachShare as! NSDictionary)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.pinOnMap()
                }
            } catch {
                print("Something went wrong")
            }
        })
    }
    
    func pinOnMap(){
        //        print("mapdata::::", mapData)
        for i in 0..<mapData.count{
            let share = ShareAnnotation()
            let lat = (mapData[i].value(forKey: "latitude") as! NSString).doubleValue
            let lon = (mapData[i].value(forKey: "longitude") as! NSString).doubleValue
            share.title = self.mapData[i]["item"]! as? String
            share.shareId = self.mapData[i]["_id"]! as? String
            share.subtitle = self.mapData[i]["description"]! as? String
            share.coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees )
            self.mapView.addAnnotation(share)
        }
        // print("pinMaps - \(parkingLots[i]["address"]! as! String)")
        
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
