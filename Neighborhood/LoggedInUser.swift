//
//  LoggedInUser.swift
//  Neighborhood
//
//  Created by Kim Vy Vo on 9/26/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation

class LoggedInUser {
    static var shared = LoggedInUser()
    var id = ""
    var username = ""
    var address = ""
    var longitude = ""
    var latitude = ""
    var contact = ""
}
