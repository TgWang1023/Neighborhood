//
//  UserModel.swift
//  Neighborhood
//
//  Created by Kim Vy Vo on 9/25/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation

class UserModel {
    static func getAllUsers(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://localhost:8000/users")
        let session = URLSession.shared
        let user = session.dataTask(with: url!, completionHandler: completionHandler)
        user.resume()
    }
    static func addNewUser(newUser: [String:String], completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/users") {
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "POST"
            let bodyData = ["username": newUser["username"]!,
                            "pass_hs": newUser["password_hs"]]
            print("got bodyData: ", bodyData)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyData)
            } catch {
                print("error in UserModel, addNewUser().")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let user = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            user.resume()
        }
    }
}
