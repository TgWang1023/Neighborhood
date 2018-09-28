//
//  EventDetailsVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/27/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController {
    
    var eventID: String = ""
    var tableData:[NSDictionary] = []

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func responsePressed(_ sender: UIButton) {
        print("I am going!!")
        EventModel.attentAnEvent(event_id: eventID, completionHandler: {
            data, response, error in
            do {
                print("Adding new event...")
                if let registerAttendee = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print("added: ", registerAttendee)
                    self.fetchEvent()
                }
            } catch {
                print("something went wrong")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        fetchEvent()
    }
    

    func fetchEvent(){
        var selectedEvent = NSDictionary()
        EventModel.getAnEvent(event_id: eventID, completionHandler:{
            data, response, error in
            do {
                if let events = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(events)
                    selectedEvent = events
                    self.tableData = events.value(forKey: "attendees") as! [NSDictionary]
                }
                DispatchQueue.main.async {
                    self.eventTitleLabel.text = selectedEvent.value(forKey: "name") as? String
                    let dateFormatter = DateFormatter()
                    let longDateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, h:mm a"
                    longDateFormatter.timeZone = .current
                    longDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let stringDate:String = (selectedEvent.value(forKey: "time") as? String)!
                    print("String Date::::", stringDate)
                    if let date = longDateFormatter.date(from: stringDate){
                        self.eventTimeLabel.text = "\(dateFormatter.string(from: date))"
                    } else {
                        print("Something went wrong!")
                    }
                    self.eventLocationLabel.text = (selectedEvent.value(forKey: "location") as? String)?.uppercased()
                    self.tableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        })
        
    }

}

extension EventDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendeeCell") as! UITableViewCell
        cell.textLabel!.text = "\(tableData[indexPath.row]["username"]!) is going"
        return cell
    }

}

