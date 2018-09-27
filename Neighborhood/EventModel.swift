//
//  EventModel.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/26/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation

class EventModel {
    static func getAllEvents(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://13.56.81.225/events")
        let session = URLSession.shared
        let event = session.dataTask(with: url!, completionHandler: completionHandler)
        event.resume()
    }
    static func getUserEvents(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://localhost:8000/events/user/\(LoggedInUser.shared.id)")
        let session = URLSession.shared
        let events = session.dataTask(with: url!, completionHandler: completionHandler)
        events.resume()
    }
    static func deleteEvent(event_id:String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/events/\(event_id)"){
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "DELETE"
            let session = URLSession.shared
            let events = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            events.resume()
        }
    }
    static func addNewEvent(newEvent: [String:String], completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/events") {
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "POST"
            let bodyData = ["name": newEvent["name"]!,
                            "time": newEvent["time"]!,
                            "location": newEvent["location"]!,
                            "host": LoggedInUser.shared.id]
            print("got bodyData: ", bodyData)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyData)
            } catch {
                print(error)
                print("error in EventModel, addNewEvent().")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let event = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            event.resume()
        }
    }
}
