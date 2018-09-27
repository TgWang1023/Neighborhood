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
        tableView.rowHeight = 75
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
        fetchUserEvents()
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
        cell.eventTimeLabel.text = tableData[indexPath.row]["time"] as! String
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
    
}
