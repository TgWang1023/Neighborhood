//
//  ShareModel.swift
//  Neighborhood
//
//  Created by Kim Vy Vo on 9/26/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation

class ShareModel {
    static func getAllShares(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://localhost:8000/shares")
        let session = URLSession.shared
        let share = session.dataTask(with: url!, completionHandler: completionHandler)
        share.resume()
    }
    static func addNewShare(newShare: [String:String], completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/shares") {
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "POST"
            let bodyData = ["item": newShare["item"]!,
                            "lending": newShare["lending"]!,
                            "isAvailable": newShare["isAVailable"]!,
                            "description": newShare["description"]!,
            ]
            print("from ShareModel:", bodyData)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyData)
            } catch {
                print("error in ShareModel, addNewShare().")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let share = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            share.resume()
        }
}
