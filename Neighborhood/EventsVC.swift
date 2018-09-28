//
//  EventsVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/24/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class EventsVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let regionRadius: CLLocationDistance = 500
    
    var tableData = [NSDictionary]()
    var mapData = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("Add event")
        performSegue(withIdentifier: "AddEditEventSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        tableView.rowHeight = 120
//        fetchUserEvents()
        let lat = (LoggedInUser.shared.latitude as NSString).doubleValue
        let lon = (LoggedInUser.shared.longitude as NSString).doubleValue
        let user_location: CLLocation = CLLocation(latitude: lat, longitude: lon)
        let user_coordinate = MKCoordinateRegion(center: user_location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(user_coordinate, animated: true)
        mapView.showsUserLocation = true
        print(tableData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMapData()
        fetchUserEvents()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        let pinImage = UIImage(named: "partyPin")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is EventAnnotation{
            let dest = segue.destination as! EventDetailsVC
            let event = sender as! EventAnnotation
            print("EventID : ", event.eventId!)
            dest.eventID = event.eventId!
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let event = view.annotation as! EventAnnotation
        print("more details????", event.eventId!)
        performSegue(withIdentifier: "EventDetailsSegue", sender: event)
    }
    
    
    func fetchMapData(){
        mapData = []
        EventModel.getAllEvents(completionHandler:{
            data, response, error in
            do {
                if let events = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    let event = events["data"]
                    if (event as! NSArray).count > 0{
                        for eachEvent in event as! NSArray{
                            self.mapData.append(eachEvent as! NSDictionary)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.pinOnMap()
                }
            } catch {
                print("Something went wrong")
            }
        })
    }
    
    func pinOnMap(){
        //        print("mapdata::::", mapData)
        self.mapView.removeAnnotations(mapView.annotations)
        for i in 0..<mapData.count{
            
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(mapData[i]["location"] as! String) {
                placemarks, error in
                let event = EventAnnotation()
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                event.title = self.mapData[i]["name"]! as? String
                event.eventId = self.mapData[i]["_id"]! as? String
                let dateFormatter = DateFormatter()
                let longDateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, h:mm a"
                longDateFormatter.timeZone = .current
                longDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let stringDate:String = self.mapData[i]["time"]! as! String
                print("String Date::::", stringDate)
                if let date = longDateFormatter.date(from: stringDate){
                    event.subtitle = "\(dateFormatter.string(from: date))"
                } else {
                    print("Something went wrong!")
                }
                
                //                event.subtitle = "\(dateFormatter.date(from: date))"
                event.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                self.mapView.addAnnotation(event)
            }
            // print("pinMaps - \(parkingLots[i]["address"]! as! String)")
            
        }
        
    }
    
    func fetchUserEvents(){
        tableData = []
        EventModel.getUserEvents(completionHandler:{
            data, response, error in
            do {
                if let events = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    let event = events["data"]
                    if (event as! NSArray).count > 0{
                        for eachEvent in event as! NSArray{
                            self.tableData.append(eachEvent as! NSDictionary)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        })
    }
}

extension EventsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as! MyEventCell
        cell.eventTitleLabel.text = tableData[indexPath.row]["name"] as! String
        cell.eventLocationLabel.text = (tableData[indexPath.row]["location"] as! String).uppercased()
        let dateFormatter = DateFormatter()
        let longDateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        longDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let stringDate:String = tableData[indexPath.row]["time"] as! String
        if let date = longDateFormatter.date(from: stringDate){
            cell.eventTimeLabel.text = "\(dateFormatter.string(from: date))"
        } else {
            print("Something went wrong!")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            EventModel.deleteEvent(event_id: self.tableData[indexPath.row]["_id"] as! String, completionHandler: {
                data, response, error in
                do {
                    if let deleteEntry = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                    }
                } catch {
                    print("something went wrong")
                }
            })
            self.fetchMapData()
            self.tableData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            
            // code for edit
        }
        delete.backgroundColor = .red
        edit.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // code here
        print(indexPath.row)
    }
    
}
