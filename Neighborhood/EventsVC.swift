//
//  EventsVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/24/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension EventsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as! MyEventCell
        cell.eventTitleLabel.text = "Event - \(indexPath.row + 1)"
        return cell
    }
}
