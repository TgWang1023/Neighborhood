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
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("Add event")
        performSegue(withIdentifier: "AddEditEventSegue", sender: nil)
    }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            // code for delete
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            
            // code for edit
        }
        delete.backgroundColor = .red
        edit.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
}
